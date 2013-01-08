class CourseChangeRecord < ActiveRecord::Base
  include CourseTeacherRelativeMethods
  validates :start_date, :end_date, :time_expression, :presence => true

  validates :teacher_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value, :start_date, :end_date]}

  validate   :not_the_same_time_expression
  def not_the_same_time_expression
    if self.course_teacher.blank?
      errors.add :base, "没有对应的课程"
    end

    if course_teacher.time_expression_array == self.time_expression_array
      errors.add :base, '调的课不能没有变化'
    end
  end

  def time_expression_array
    array = JSON.parse(self.time_expression || "[]")
    array.map do |item|
      [item["number"]].flatten.map do |number|
        {:weekday => item["weekday"].to_i, :number => number}
      end
    end.flatten
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
