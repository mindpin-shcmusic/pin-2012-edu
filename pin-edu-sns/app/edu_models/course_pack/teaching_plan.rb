class TeachingPlan < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id


  belongs_to :course

  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  has_many :chapters
  
  validates :title, :desc, :creator, :course, :presence => true

  include CourseTeacherRelativeMethods

  before_create :validate_semester_value

  scope :with_course_teacher, lambda { |teacher_user, semester, course| {:conditions => 
                            {
                              :semester_value => semester.value,
                              :teacher_user_id => teacher_user.id,
                              :course_id => course.id
                            }
                          } 
                        }


  def validate_semester_value
    return true if Semester.get_by_value(self.semester_value).value == self.semester_value
    return false
  end



  module UserMethods
    def self.included(base)
      base.has_many :teaching_plans, :class_name => 'TeachingPlan', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      
    end
  end
  
end
