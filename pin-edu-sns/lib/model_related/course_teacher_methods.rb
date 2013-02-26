module CourseTeacherMethods

  def self.params_to_time_expression(time_expression_params)

    time_expression = time_expression_params.map do |time|
      time = time.split(',')
      weekday = time[0].to_i
      number = time[1].to_i

      {:weekday => weekday, :number => number}
    end
  end


end