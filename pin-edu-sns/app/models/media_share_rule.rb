class MediaShareRule < ActiveRecord::Base
  attr_reader :deleting
  after_save :enqueue_build_share
  after_save :update_achievement

  belongs_to :media_resource

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  def build_expression(options = {})
    options.assert_valid_keys :users, :courses, :teams

    options[:users]   ||= []
    options[:courses] ||= []
    options[:teams]   ||= []

    @deleting = persisted? ? deleting_receiver_ids(options) : []

    delete_share
    
    self.expression = options.to_json
  end

  def expression
    exp = read_attribute(:expression)
    exp && JSON.parse(exp, :symbolize_names => true).reduce({}) do |sanitized, (k, v)|
      sanitized[k] = v.map(&:to_i)
      sanitized
    end
  end

  def expression_receiver_ids
    user_ids = (expression[:users]                  +
                courses_or_teams_receiver_ids(Team) +
                courses_or_teams_receiver_ids(Course)).flatten.compact.uniq

    user_ids.delete(self.media_resource.creator.id)

    user_ids
  end

  def expression_receivers
    User.find expression_receiver_ids
  end

  def deleting_receivers
    User.find deleting_receiver_ids
  end

  def delete_share
    MediaShare.where('media_resource_id = ? and receiver_id in (?)', self.media_resource_id, self.deleting).delete_all
  end

  def build_share
    expression_receivers.each {|receiver|
      share = MediaShare.find_or_initialize_by_media_resource_id_and_receiver_id self.media_resource.id,
                                                                                 receiver.id
      share.creator = self.creator
      share.save
    }
  end

  private

  def deleting_receiver_ids(options)
    return [] if expression.nil?
    ArrayDiff.deleted(expression_receiver_ids, options[:users].map(&:to_i))
  end

  def courses_or_teams_receiver_ids(team_or_course)
    team_or_course.find(expression[team_or_course.to_s.tableize.to_sym]).map(&:get_user_ids).flatten.sort
  end

  def enqueue_build_share
    BuildMediaShareResqueQueue.enqueue(self.id)
  end

  def update_achievement
    achievement = Achievement.find_or_initialize_by_user_id(self.creator.id)
    achievement.share_rate = self.creator.share_rate
    achievement.save
  end

  module UserMethods
    def self.included(base)
      base.has_many :media_share_rules,
                    :foreign_key => 'creator_id'

      base.send     :include,
                    InstanceMethods
    end

    module InstanceMethods
      def share_rate
        shared_count = self.media_share_rules.count
        total_count  = self.media_resources.count

        shared_count / total_count.to_f * 100
      end
    end
  end

  module MediaResourceMethods
    def self.included(base)
      base.has_one :media_share_rule

      base.send    :include,
                   InstanceMethods
    end

    module InstanceMethods
      def share_to(options)
        rule = MediaShareRule.find_or_initialize_by_media_resource_id(self.id)
        rule.creator = self.creator

        rule.build_expression(options)
        rule.save
      end

      def share_to_expression(expression_string)
        share_to(JSON.parse expression_string, :symbolize_names => true)
      end
    end
  end
end
