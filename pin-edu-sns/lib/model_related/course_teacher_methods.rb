module CourseTeacherMethods

  def self.combine_time_expression(time_expression_params)
    weeks = Hash.new(0)
    hours = Hash.new(0)
    time_expression_params.each do |time|

      time = time.split(',')
      weekday = time[0].to_i
      hour = time[1].to_i

      if weeks.has_key?(weekday)
        weeks[weekday][:number] << hour
        next
      end

      weeks[weekday] = {:weekday => weekday, :number => [hour]}

    end

    time_expression = []
    weeks.each do |week|
      time_expression << week[1]
    end

    time_expression
  end


end