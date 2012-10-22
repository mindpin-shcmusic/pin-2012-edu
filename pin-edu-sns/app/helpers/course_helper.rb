module CourseHelper

  def course_tab_link(course, name, text, current, count=0)
    span_text = content_tag :span, text
    count_text = count > 0 ? (content_tag :span, count, :class => 'count') : ''

    link_text = span_text + count_text

    klass = (name.to_sym == current.to_sym) ? "link #{name} current" : "link #{name}"
    link_to link_text, "/courses/#{course.id}?tab=#{name}", :class=>klass
  end


  def get_teacher_course_by_weekday_and_number(teacher_courses, weekday, number)
    teacher_courses.each do |course_teacher|
      time_expression = JSON.parse(course_teacher.time_expression)
      time_expression.each do |expression|
        if (expression['weekday'] == weekday) && (expression['number'].include?(number))
          return course_teacher.course
        end
      end
      
    end

    return nil
  end


  def change_to_weekday(weekday)
    case weekday
    when 1
      label = '星期一'
    when 2
      label = '星期二'
    when 3
      label = '星期三'
    when 4
      label = '星期四'
    when 5
      label = '星期五'
    when 6
      label = '星期六'
    when 0
      label = '星期日'
    end
  end

  def change_to_course_number(number)
    case number
    when 0
      number_label = ''
    when 1
      number_label = '第一节'
    when 2
      number_label = '第二节'
    when 3
      number_label = '第三节'
    when 4
      number_label = '第四节'
    when 5
      number_label = '第五节'
    when 6
      number_label = '第六节'
    when 7
      number_label = '第七节'
    when 8
      number_label = '第八节'
    when 9
      number_label = '第九节'
    when 10
      number_label = '第十节'
    when 11
      number_label = '第十一节'
    when 12
      number_label = '第十二节'
    end
  end

end