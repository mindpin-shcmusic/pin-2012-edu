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
    return "" if number == 0
    "第#{%w{一 二 三 四 五 六 七 八 九 十 十一 十二}[number - 1]}节"
  end

  def course_change_record_times
    now_time = Time.now
    now_wday = now_time.wday
    now_wday = 7 if now_wday == 0

    week_start_time = now_time - (now_wday - 1).day
    week_end_time = now_time + (7 - now_wday).day
    times = []
    times << [week_start_time,week_end_time]
    4.times do |i|
      start_time = week_start_time + ((i+1)*7).day
      end_time = week_end_time + ((i+1)*7).day

      times << [start_time, end_time]
    end

    times.map do |time|
      [
        "#{time[0].strftime('%Y%m%d')} - #{time[1].strftime('%Y%m%d')}",
        "#{time[0].strftime('%Y%m%d')},#{time[1].strftime('%Y%m%d')}",
      ]
    end
  end

  def course_nav_link(name, course, sym = '')
    href = sym.blank? ? "/courses/#{course.id}" : "/courses/#{course.id}/nav_#{sym}"

    @cnav ||= ''

    link_to name, href, :class => "item #{@cnav == sym ? 'current' : ''}"
  end

  # ---------------
  def page_head_cell(img_url, title, desc)
    s1 = content_tag :div, :class => 'image' do
      jimage img_url, :width => 80, :height => 80
    end

    s2 = content_tag :div, title, :class => 'ctitle'
    s3 = content_tag :div, sanitize(desc), :class => 'cdesc'

    content_tag :div, :class => 'page-head-cell' do
      s1 + s2 + s3
    end
  end

  def page_images_grid(image_hashs)
    content_tag :div, :class => 'page-images-grid' do
      s3 = image_hashs.map do |ih|
        s1 = content_tag :div, :class => 'image' do
          jimage ih[:url], :width => 200, :height => 150
        end
        s2 = content_tag :div, ih[:title], :class => 'title'
        content_tag :div, :class => 'cell' do
          s1 + s2
        end
      end.join('').html_safe
    end
  end

  def page_course_resources(course)
    hashs = course.chapters.map do |ch|
      hash = Hash.new('')
      hash[:url] = ''
      hash[:title] = '无标题'

      cw = ch.course_wares[0]
      hash[:title] = ch.title

      if !cw.blank?

      end

      hash
    end
  end

  def page_cell_head_and_more(title, desc, more, url)
    content_tag :div, :class => 'page-cell-head-and-more' do
      s1 = content_tag :div, title, :class => 'title'
      s2 = content_tag :div, desc, :class => 'desc'
      s3 = content_tag :a, more, :href => url, :class => 'more'
      s1 + s2 + s3
    end
  end

  def page_cell_head_no_more(title, desc)
    content_tag :div, :class => 'page-cell-head-and-more' do
      s1 = content_tag :div, title, :class => 'title'
      s2 = content_tag :div, desc, :class => 'desc'
      s1 + s2
    end
  end

  def page_user_small_cards(users)
    content_tag :div, :class => 'page-user-cards' do
      users.map do |user|
        content_tag :div, :class => 'card' do
          s1 = avatar user, :tiny
          s2 = content_tag :div, user.real_name, :class => 'name'
          s1 + s2
        end
      end.join('').html_safe
    end
  end

end