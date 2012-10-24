class MentorCourse < ActiveRecord::Base
  belongs_to :user,
             :class_name => 'User',
             :foreign_key => 'teacher_user_id'

  has_many :mentor_students, 
           :class_name => 'MentorStudent', :foreign_key => :mentor_course1

  has_many :mentor_students, 
           :class_name => 'MentorStudent', :foreign_key => :mentor_course2

  has_many :mentor_students, 
           :class_name => 'MentorStudent', :foreign_key => :mentor_course3


  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :mentor_courses,
                    :class_name  => 'MentorCourse',
                    :foreign_key => :teacher_user_id


      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
       
    end
  end
end
