class CourseStudent < ActiveRecord::Base
  belongs_to :course
  belongs_to :student_user, :class_name => 'User', :foreign_key => :student_user_id

  validates :course, :student_user, :presence => true
end
