module CourseHelper

  def course_tab_link(course, name, text, current, count=0)
    span_text = content_tag :span, text
    count_text = count > 0 ? (content_tag :span, count, :class => 'count') : ''

    link_text = span_text + count_text

    klass = (name.to_sym == current.to_sym) ? "link #{name} current" : "link #{name}"
    link_to link_text, "/courses/#{course.id}?tab=#{name}", :class=>klass
  end

end