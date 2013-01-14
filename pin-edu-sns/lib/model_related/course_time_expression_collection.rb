class CourseTimeExpressionCollection
  attr_reader :weekday, :number, :weekday_str, 
    :number_str, :start_time_str, :end_time_str,:class_time,
    :weekday_number_str, :course_time_expressions
  def initialize(course_time_expressions)
    @course_time_expressions = course_time_expressions

    expression = course_time_expressions.first
    @weekday = expression.weekday
    @number = expression.number
    @weekday_str = expression.weekday_str
    @number_str = expression.number_str
    @start_time_str = expression.start_time_str
    @end_time_str = expression.end_time_str
    @weekday_number_str = expression.weekday_number_str
    @class_time = expression.class_time
  end

  def conflict?
    course_time_expressions.count != 1
  end

  def course_time_expression
    course_time_expressions.first
  end

  def <=>(other)
    self.course_time_expression <=> other.course_time_expression
  end

  def >=(other)
    self.course_time_expression >= other.course_time_expression
  end
end