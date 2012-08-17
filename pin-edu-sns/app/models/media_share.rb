# encoding: utf-8

class MediaShare < ActiveRecord::Base
  belongs_to :media_resource
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'

  validates  :media_resource, :presence => true
  validates  :creator, :presence => true
  validates  :receiver, :presence => true

  after_create :send_tip_message_for_receiver_on_create
  def send_tip_message_for_receiver_on_create
    receiver = self.receiver

    return true if receiver.blank?
    return true if receiver == self.creator

    receiver.media_share_tip_message.put("#{self.creator.name} 给你分享了一个资源", self.id)
    receiver.media_share_tip_message.send_count_to_juggernaut
  end

  after_destroy :send_tip_message_on_destroy
  def send_tip_message_on_destroy
    receiver = self.receiver

    if !receiver.blank?
      receiver.media_share_tip_message.delete(self.id)
      receiver.media_share_tip_message.send_count_to_juggernaut
    end
  end

  # 给 User 类扩展方法，User类 include 这个 module
  module UserMethods
    def self.included(base)
      base.has_many :received_media_shares, :class_name => 'MediaShare', :foreign_key => :receiver_id
      base.has_many :received_shared_media_resources, :through => :received_media_shares, :source => :media_resource

      base.has_many :created_media_shares, :class_name => 'MediaShare', :foreign_key => :creator_id
      base.has_many :created_shared_media_resources, :through => :created_media_shares, :source => :media_resource

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def linked_sharers
        User.joins('inner join media_shares on media_shares.creator_id = users.id').
          where('media_shares.receiver_id = ?',self.id).group('users.id')
      end

      def shared_resources_from(user)
        MediaResource.joins('inner join media_shares on media_shares.media_resource_id = media_resources.id').
          where('media_shares.receiver_id = ? and media_shares.creator_id = ?',self.id,user.id)          
      end
    end

  end


  # 给 MediaResource 类扩展方法，MediaResource 类 include 这个 module
  module MediaResourceMethods
    def self.included(base)
      base.has_many :media_shares
      base.has_many :shared_receivers, :through => :media_shares, :source => :receiver

      base.send(:extend, ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      def shared_with(user)
        joins(:media_shares).where('media_shares.receiver_id = ?', user.id)
      end
    end

    module InstanceMethods
      
      # 判断是否已经分享给该用户
      def shared_to?(user)
        receivers = self.shared_receivers

        if receivers.any?
          receivers.each do |receiver|
            if receiver == user
              return true
            end
          end         
        end

        return false
        
      # 结束 shared_to
      end


      # 取得最上层目录对象
      def toppest_resource(media_resource)
        if media_resource.dir_id == 0
          return media_resource
        else
          toppest_resource(media_resource.dir)
        end
      end
      # 结束 toppest_resource

    end
  end


  # 设置全文索引字段
  define_index do
    # fields
    indexes media_resource.name
    indexes receiver_id
    
    # attributes
    has created_at, updated_at

    set_property :delta => true
  end

end
