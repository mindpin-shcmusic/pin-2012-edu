class MentorCourse < ActiveRecord::Base
  belongs_to :user,
             :class_name => 'User',
             :foreign_key => 'teacher_user_id'


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
