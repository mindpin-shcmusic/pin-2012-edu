module CourseHelper

  def course_tab_link(course, name, text, current, semester, count=0)
    span_text = content_tag :span, text
    count_text = count > 0 ? (content_tag :span, count, :class => 'count') : ''

    link_text = span_text + count_text

    klass = (name.to_sym == current.to_sym) ? "link #{name} current" : "link #{name}"
    link_to link_text, "/courses/#{course.id}?tab=#{name}&semester=#{semester.value}", :class=>klass
  end

  def admin_course_tab_link(course, name, text, current, semester, count=0)
    span_text = content_tag :span, text
    count_text = count > 0 ? (content_tag :span, count, :class => 'count') : ''

    link_text = span_text + count_text

    klass = (name.to_sym == current.to_sym) ? "link #{name} current" : "link #{name}"
    link_to link_text, "/admin/courses/#{course.id}?tab=#{name}&semester=#{semester.value}", :class=>klass
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

  # 根据 0-7 获得星期字符串
  def change_to_weekday(weekday)
    "星期#{%w{ 日 一 二 三 四 五 六 }[weekday]}"
  end

  # 根据 0-7 获得本周内的对应日期
  def change_to_weekdate(weekday)
    wd = weekday
    wd = 7 if wd == 0
    now = Time.now
    date = now + (wd - now.wday).days
    date.strftime('%Y-%m-%d')
  end

  def change_to_course_number(number)
    "第#{%w{ 一 二 三 四 五 六 七 八 九 十 十一 十二}[number + 1]}节"
  end

end