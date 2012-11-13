# -*- coding: utf-8 -*-
class CourseScoreList < ActiveRecord::Base
  has_many :course_score_records
  accepts_nested_attributes_for :course_score_records

  scope :with_semester, lambda {|semester| where('semester_value = ?', semester.value)}

  default_scope order('id DESC')

  include CourseTeacherRelativeMethods
  include Paginated
  include Pacecar

  def finished_ratio
    records = self.course_score_records
    "#{records.select(&:is_finished?).count}/#{records.count}"
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_score_lists,
                    :foreign_key => :teacher_user_id

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def create_score_list(options)
        semester = options[:semester]
        course   = options[:course]

        raise Course::InvalidCourseParams.new if course.blank? || semester.blank?

        title    = options[:title].blank? ?
        "#{semester.value}学期#{course.name}(#{self.real_name})学生成绩单" : options[:title]

        list = self.course_score_lists.\
        find_or_initialize_by_semester_value_and_course_id :semester_value => semester.value,
                                                           :course_id      => course.id

        return list if list.persisted?

        list.title = title
        list.save

        students = course.get_students :semester     => semester,
                                       :teacher_user => self

        students.each do |student_user|
          student_user.course_score_records.create :student_user      => student_user,
                                                   :course_score_list => list
        end

        list
      end
      
    end

  end


end

