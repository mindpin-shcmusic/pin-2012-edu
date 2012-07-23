class MediaShareRule < ActiveRecord::Base
  after_commit :enqueue_build_share
  after_create :update_achievement

  belongs_to :media_resource

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  def build_expression(options = {})
    options[:users]   ||= []
    options[:courses] ||= []
    options[:teams]   ||= []

    self.expression = options.to_json
  end

  def expression
    exp = read_attribute(:expression)
    exp && JSON.parse(exp, :symbolize_names => true)
  end

  def get_courses_receiver_ids
    get_courses_or_team_receiver_ids Course
  end

  def get_teams_receiver_ids
    get_courses_or_team_receiver_ids Team
  end

  def get_receiver_ids
    user_ids = (expression[:users] + get_courses_receiver_ids + get_teams_receiver_ids).flatten.compact.uniq
    user_ids.delete(self.media_resource.creator.id)

    user_ids
  end

  def get_receivers
    User.find get_receiver_ids
  end

  def build_share
    get_receivers.each {|user|
      MediaShare.create :creator        => self.media_resource.creator,
                        :media_resource => self.media_resource,
                        :receiver       => user
    }
  end

  private

  def get_courses_or_team_receiver_ids(team_or_course)
    team_or_course.find(expression[team_or_course.to_string.tableize.to_sym]).map {|org| [org.teacher, org.students]}.flatten.map(&:user_id)
  end

  def enqueue_build_share
    BuildMediaShareResqueQueue.enqueue(self.id)
  end

  def update_achievement
    rate = self.creator.share_rate

    achievement = Achievement.find_or_initialize_by_user_id(self.creator.id)
    achievement.share_rate = rate
    achievement.save
    UserShareRateTipMessage.notify_share_rank achievement.user
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
        rule = MediaShareRule.new
        rule.media_resource = self
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