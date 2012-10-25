class CourseStudentAssign < ActiveRecord::Base
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  validates :student_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value]}

  include CourseTeacherRelativeMethods
end
