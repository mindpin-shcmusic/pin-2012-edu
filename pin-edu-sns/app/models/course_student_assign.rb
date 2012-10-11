class CourseStudentAssign < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  validates :course_id, :presence => true
  validates :teacher_user_id, :presence => true
  validates :student_user_id, :presence => true
end