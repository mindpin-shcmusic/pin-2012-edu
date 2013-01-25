class TeachingPlan < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id


  belongs_to :course

  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  has_many :chapters
  
  validates :title, :desc, :creator, :presence => true

  #validates :teacher_user, :presence => true,
  #  :uniqueness => {:scope => [:course_id, :semester_value]}


  #include CourseTeacherRelativeMethods


  module UserMethods
    def self.included(base)
      base.has_many :teaching_plans, :class_name => 'TeachingPlan', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      
    end
  end
  
end
