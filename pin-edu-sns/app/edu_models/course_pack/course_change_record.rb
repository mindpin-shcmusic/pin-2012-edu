class CourseChangeRecord < ActiveRecord::Base
  include CourseTeacherRelativeMethods
  validates :start_date, :end_date, :time_expression, :location, :presence => true

  validates :teacher_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value, :start_date, :end_date]}

end
