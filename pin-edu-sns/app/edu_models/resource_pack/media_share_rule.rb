class MediaShareRule < ActiveRecord::Base
  after_save :enqueue_build_share
  def enqueue_build_share
    BuildMediaShareResqueQueue.enqueue(self.id)
  end

  belongs_to :media_resource

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  def build_expression(options = {})
    options.assert_valid_keys :student_user_ids, :teacher_user_ids, :course_teacher_ids

    options[:student_user_ids]     ||= []
    options[:teacher_user_ids]     ||= []
    options[:course_teacher_ids]   ||= []
    user_ids = options[:student_user_ids] + options[:teacher_user_ids]

    if persisted? && !expression.blank?
      delete_ids = ArrayDiff.deleted(expression_receiver_ids, user_ids.map(&:to_i))
      MediaShare.where('media_resource_id = ? and receiver_id in (?)', self.media_resource_id, delete_ids).delete_all
    end
    
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
    user_ids = []

    user_ids += expression[:student_user_ids]
    user_ids += expression[:teacher_user_ids]
    user_ids += CourseTeacher.find(expression[:course_teacher_ids]).map do |course_teacher|
      users = []
      users += course_teacher.student_users
      users << course_teacher.teacher_user
      users
    end.flatten.compact.uniq.map{|user|user.id}

    user_ids.delete(self.media_resource.creator.id)

    user_ids
  end

  def expression_receivers
    User.find expression_receiver_ids
  end

  def build_share
    expression_receivers.each {|receiver|
      share = MediaShare.find_or_initialize_by_media_resource_id_and_receiver_id self.media_resource.id,
                                                                                 receiver.id
      share.creator = self.creator
      share.save
    }
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
        total_count  = self.media_resources.count
        return 0 if 0 == total_count
        shared_count = self.media_share_rules.count

        shared_count / total_count.to_f * 100
      end
    end
  end

  module MediaResourceMethods
    def self.included(base)
      base.has_one :media_share_rule, :dependent => :destroy

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

      def shared_course_teacher_ids
        return [] if self.media_share_rule.blank?
        self.media_share_rule.expression[:course_teacher_ids]
      end

      def shared_student_user_ids
        return [] if self.media_share_rule.blank?
        self.media_share_rule.expression[:student_user_ids]
      end

      def shared_teacher_user_ids
        return [] if self.media_share_rule.blank?
        self.media_share_rule.expression[:teacher_user_ids]
      end
    end
  end
end
