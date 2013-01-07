class CourseChangeRecord < ActiveRecord::Base
  include CourseTeacherRelativeMethods
  validates :start_date, :end_date, :time_expression, :presence => true

  validates :teacher_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value, :start_date, :end_date]}

  def time_expression_array
    JSON.parse(self.time_expression || "[]")
  end

  def time_expression_array=(time_expression_array)
    self.time_expression = time_expression_array.to_json
  end

  module CourseTeacherMethods
    def course_change_records
      CourseChangeRecord.where(
        :course_id => self.course_id,
        :teacher_user_id => self.teacher_user_id,
        :semester_value => self.semester_value
        )
    end
  end
end
