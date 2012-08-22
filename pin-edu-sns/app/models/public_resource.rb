# -*- coding: utf-8 -*-
class PublicResource < ActiveRecord::Base
  class Kind
    UPLOAD = "UPLOAD"
    LINK = "LINK"
  end
  belongs_to :file_entity
  belongs_to :media_resource
  belongs_to :creator, :class_name  => 'User', :foreign_key => 'creator_id'
  belongs_to :category

  scope :of_category, lambda{|category| where(:category_id => category.id)}
  scope :no_category, where(:category_id=>nil)

  def is_upload?
    self.kind == PublicResource::Kind::UPLOAD
  end

  def is_share?
    self.kind == PublicResource::Kind::LINK
  end


  def self.upload_by_user(user, file)
    file_entity = FileEntity.new(:attach => file)
    public_resource = PublicResource.create(
      :creator => user,
      :file_entity => file_entity,
      :name => file_entity.attach_file_name,
      :kind => PublicResource::Kind::UPLOAD
    )
  end

  def real_file_entity
    return file_entity if is_upload?
    return media_resource.file_entity
  end

  # 给 User 类扩展方法，User类 include 这个 module
  module UserMethods
    def self.included(base)
      base.has_many :shared_public_resources, 
                    :class_name => 'PublicResource', :foreign_key => :creator_id,
                    :conditions => lambda { "kind = '#{PublicResource::Kind::LINK}'" }

      base.has_many :uploaded_public_resources, 
                    :class_name => 'PublicResource', :foreign_key => :creator_id,
                    :conditions => lambda { "kind = '#{PublicResource::Kind::UPLOAD}'" }

 
      base.has_many :public_resources,
                    :class_name  => 'User',
                    :foreign_key => 'creator_id'

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
    
    end

  end
  # 结束 UserMethods


  # 给 MediaResource 类扩展方法，MediaResource 类 include 这个 module
  module MediaResourceMethods
    def self.included(base)
      base.has_one :shared_public_resource,
                   :class_name  => 'PublicResource', :foreign_key => 'media_resource_id'

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      # 分享到公共资源
      def share_public(category = nil)
        public_resource = self.shared_public_resource
        if public_resource.blank?
          PublicResource.create(
            :creator => self.creator,
            :name => self.name,
            :media_resource => self,
            :kind => PublicResource::Kind::LINK,
            :category => category
          )
        else
          public_resource.update_attribute(:category, category)
        end
      end

      # 判断是否添加到公共资源库
      def is_public?
        !self.shared_public_resource.blank?
      end

      def category_of_shared_public_resource
        shared_public_resource.blank? ? nil : shared_public_resource.category
      end

    end

  end

  # 设置全文索引字段
  define_index do
    # fields
    indexes name, :sortable => true
    indexes creator_id
    
    # attributes
    has kind, created_at, updated_at

    set_property :delta => true
  end
  
end
