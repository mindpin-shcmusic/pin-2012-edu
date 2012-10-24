class MentorStudent < ActiveRecord::Base
  belongs_to :mentor_note

  belongs_to :user,
             :class_name => 'User',
             :foreign_key => 'student_user_id'

  belongs_to :mentor_course_1,
             :class_name => 'MentorCourse',
             :foreign_key => 'mentor_course1'


  belongs_to :mentor_course_2,
             :class_name => 'MentorCourse',
             :foreign_key => 'mentor_course2'


  belongs_to :mentor_course_3,
             :class_name => 'MentorCourse',
             :foreign_key => 'mentor_course3'


  scope :with_student, lambda {|student| {:conditions => ['student_user_id = ?', student.id]}}


  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :mentor_students,
                    :class_name  => 'MentorStudent',
                    :foreign_key => :student_user_id


      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
       
    end
  end

end
