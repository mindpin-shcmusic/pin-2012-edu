# -*- coding: utf-8 -*-
class CourseScoreList < ActiveRecord::Base
  has_many :course_score_records

  include CourseTeacherRelativeMethods

  module UserMethods
    def self.included(base)
      base.has_many :course_score_lists
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def create_list(options)
        semester = options[:semester]
        course   = options[:course]
        title    = options[:course] ||
                   "#{semester.value}学期#{course.name}(#{self.real_name})学生成绩单"

        raise Course::InvalidCourseParams.new if course.blank? ||
                                                 semester.blank?

        list = self.course_score_lists.\
        find_or_initialize_by_semester_value_and_course_id_and_title :title          => title,
                                                                     :semester_value => semester,
                                                                     :course_id      => course

        students = course.get_students :semester     => semester,
                                       :teacher_user => self

        students.map do |student_user|
          student.course_score_record.create :student_user      => student_user,
                                             :course_score_list => list
        end

        list
      end
      
    end

  end


end

