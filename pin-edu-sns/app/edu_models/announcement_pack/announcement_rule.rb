# -*- coding: utf-8 -*-
class AnnouncementRule < ActiveRecord::Base
  class InvalidAnnouncementRuleParams < Exception;end

  after_save :enqueue_build_announcement

  belongs_to :announcement
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => 'creator_id'

  validate :able_to_create

  def build_expression(options = {})
    options.assert_valid_keys :courses, :teams, :all_teachers, :all_students
    options[:courses] ||= []
    options[:teams] ||= []
    self.expression = options.to_json
  end
  
  def expression
    exp = read_attribute(:expression)
    exp && JSON.parse(exp, :symbolize_names => true).reduce({}) do |sanitized, (k, v)|
      sanitized[k] = v.map(&:to_i)
      sanitized
    end
  end

  def expression_receivers
    return admin_receivers if self.creator.is_admin?
    teacher_receivers
  end

  def build_announcement
    self.expression_receivers.each {|receiver|
      receiver_key = AnnouncementUser.find_or_initialize_by_announcement_id_and_user_id self.announcement.id,
                                                                                        receiver.id
      next if receiver_key.persisted?
      receiver_key.save
    }
  end

private

  def validate_options(options)
  end

  def teacher_receivers
    Course.find(expression[:courses]).map{|course| course.get_students :semester => Semester.now, :teacher_user => self.creator}.flatten.uniq
  end

  def admin_receivers
    return admin_all_users_receivers if self.expression.blank?
    return admin_all_teachers_receivers if self.expression[:all_teachers]
    return admin_all_teachers_receivers if self.expression[:all_students]
    admin_courses_receivers.concat(admin_all_students_receivers)
  end

  def admin_all_users_receivers
    User.all.reject {|user| user == self.creator}
  end

  def admin_courses_receivers
    Course.find(expression[:courses]).map {|course| course.current_semester_users}.flatten.uniq
  end

  def admin_teams_receivers
    Team.find(expression[:teams]).map {|team| team.student_users}
  end

  def admin_all_teachers_receivers
    User.all.select {|user| user.is_teacher?}
  end

  def admin_all_students_receivers
    User.all.select {|user| user.is_student?}
  end

  def able_to_create
    errors.add :base,
               '没有发布通知的权限' if self.creator.is_student?
  end

  def enqueue_build_announcement
    BuildAnnouncementResqueQueue.enqueue(self.id)
  end

  module AnnouncementMethods
    def self.included(base)
      base.has_one :announcement_rule
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
