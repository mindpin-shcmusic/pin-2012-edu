# -*- coding: utf-8 -*-
class AnnouncementRule < ActiveRecord::Base
  after_save :enqueue_build_announcement

  belongs_to :announcement
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  validate :able_to_create

  def build_expression(options = {})
    options.assert_valid_keys :courses
    options[:courses] ||= self.creator.courses.map(&:id) if self.creator.is_teacher?
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
    Course.find(expression[:courses]).map(&:student_users).flatten.map(&:id).map().sort
  end

  def expression_receivers
    return User.not_admin if self.creator.is_admin?
    User.find expression_receiver_ids
  end

  def build_announcement
    self.expression_receivers.each {|receiver|
      receiver = AnnouncementUser.find_or_initialize_by_announcement_id_and_user_id self.announcement.id,
                                                                                    receiver.id
      receiver.save
    }
  end

private

  def able_to_create
    errors.add :base,
               '没有发布通知的权限' if self.creator.is_student?
  end

  def enqueue_build_announcement
    BuildAnnouncementResqueQueue.enqueue(self.id)
  end

  module AnnouncementMethods
    def self.included(base)
      base.has_one :homework_assign_rule
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def announce_to(options={})
        rule = AnnouncementRule.find_or_initialize_by_announcement_id(self.id)
        rule.creator = self.creator

        rule.build_expression(options)
        rule.save
      end

      def announce_to_expression(expression_string)
        announce_to(JSON.parse expression_string, :symbolize_names => true)
      end

    end

  end

end
