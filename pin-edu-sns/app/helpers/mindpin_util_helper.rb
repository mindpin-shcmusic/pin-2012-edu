# -*- coding: utf-8 -*-
module MindpinUtilHelper
  def self.included(base)
    base.send(:include, LayoutMethods)
    base.send(:include, FlashInfoMethods)
    base.send(:include, AvatarMethods)
    base.send(:include, UserSignMethods)
    base.send(:include, FormDomsMethods)
    base.send(:include, ImageMethods)
    base.send(:include, TimeMethods)
    base.send(:include, CommentMethods)
    base.send(:include, FloatBoxMethods)
    base.send(:include, UploadMethods)
    base.send(:include, TextMethods)
    base.send(:include, CourseMethods)
  end

  module LayoutMethods
    
    # 给当前页面设置标题
    def htitle(str)
      content_for :title do
        str
      end
    end

    # 生成面包屑导航
    def hbreadcrumb(str, url = nil, options = {})
      url ||= 'javascript:;'

      content_for :breadcrumb do
        content_tag :div, :class => 'link' do
          content_tag(:a, truncate_u(str, 16), :href => url)
        end
      end
    end

    def hgoback(url)
      content_for :breadcrumb do
        content_tag :div, :class => 'link goback' do
          content_tag(:a, '返回上级', :href => url)
        end
      end
    end

  end

  module FlashInfoMethods
    # 回显校验信息
    def flash_info
      re = []
      [:notice, :error, :success].each do |kind|
        msg = flash[kind]
        re << "<div class='flash-info #{kind}'><span>#{msg}</span></div>" if !msg.blank?
      end
      raw re * ''
    end
  end

  module AvatarMethods
    def avatar(user, style = :normal)
      klass = ['page-avatar-img', style]*' '

      if user.blank?
        alt   = '未知用户'
        src   = User.new.logo.url(style)
        meta  = 'unknown-user'
      else
        alt   = user.real_name
        src   = user.logo.url(style)
        meta  = dom_id(user)
      end
      
      # jimage src, :alt => alt, 
      #             :class => klass, 
      #             :'data-meta' => meta

      image_tag src, :alt => alt, 
                     :class => klass, 
                     :'data-meta' => meta
    end
  
    def avatar_link(user, style = :normal)
      href  = user.blank? ? 'javascript:;' : "/users/#{user.id}"
      title = user.blank? ? '未知用户' : user.real_name
      
      link_to href, :title=>title do
        avatar(user, style)
      end
    end
  end

  module UserSignMethods
    def user_link(user)
      return '未知用户' if user.blank?
      link_to user.real_name, "/users/#{user.id}", :class=>'u-name'
    end

    def current_user_title
      return '老师' if current_user.is_teacher?
      return '同学' if current_user.is_student?
    end

    def user_name(user)
      return "未知用户" if user.blank?
      user.name
    end

    def user_real_name(user)
      return "未知用户" if user.blank?
      user.real_name
    end

    def user_email(user)
      return "未知用户" if user.blank?
      user.email
    end
  end

  module FormDomsMethods
    def jcheckbox(name, value, checked, text)
      span_klass = checked ? 'c checked' : 'c'

      content_tag :div, :class => 'pie-j-checkbox' do
        re1 = content_tag :span, :class => span_klass do
          check_box_tag(name, value, checked)
        end

        re2 = link_to(text.html_safe, 'javascript:;', :class => 'text')

        re1 + re2
      end
    end

    def jsearchbar(url, options = {})
      placeholder = options[:placeholder] || '搜索…'
      default_value = options[:default] || ''

      # %form.page-search-bar{:action=>url, :method=>'get', :'data-enter-to-submit'=>true}
      #   .field.placeholder.need
      #     %label 输入搜索内容
      #     %input{:name=>'query', :type=>'text', :value => query || ''}
      #     %a.go{:href=>'javascript:;'} 搜索

      form_tag url, :method=>:get, :class=>'page-search-bar', :'data-enter-to-submit'=>true do
        content_tag :div, :class=>'field placeholder need' do
          content_tag(:label, placeholder) +
          text_field_tag(:query, default_value) +
          link_to('搜索', 'javascript:;', :class=>'go')
        end
      end
    end

    def jfbutton(text)
      content_tag :a, text, :href => 'javascript:;',
                            :class => 'form-button'
    end

    # 表单里的提交按钮
    def jfsubmit(text)
      # %a.form-submit-button{:href=>'javascript:;'} 登录
      content_tag :a, text, :href => 'javascript:;',
                            :class => 'form-submit-button'
    end

    def jfsubmit_stop(text, href)
      content_tag :a, text, :href => href,
                            :class => 'form-submit-button stop'
    end

    def jfcancel(text)
      # %a.form-cancel-button{:href=>'javascript:history.go(-1);'} 返回
      content_tag :a, text, :href => 'javascript:history.go(-1);',
                            :class => 'form-cancel-button'
    end

    def jdelete(text, href, confirm_text)
      content_tag :a, text, :href => 'javascript:;',
                            :class => 'page-jdelete',
                            :'data-jconfirm' => confirm_text,
                            :'data-jhref' => href
    end

    def semester_selector(t, value)
      value ||= Semester.now.value
      arr = Semester.get_recent_semesters.collect do |p| 
        [ p.to_s, p.value ] 
      end

      t.select(:semester_value, arr, 
        {:selected => value}, 
        {:class => 'semester-select'})
    end

    def team_selector
      select_tag("by_team_id", 
        options_from_collection_for_select(Team.all, "id", "name"),
        :class => 'team-selector'
      )
    end

    def course_selector(f)
      arr = Course.all.map{|course|[course.name,course.id]}

      f.select(:course_id, arr,{:include_blank => true},
        {:data => {:placeholder => '请选择课程'}, :class => 'course-select'}
      )
    end

    def student_selector(f)
      arr = []

      f.select(:student_user_id, arr,{:include_blank => true},
        {:data => {:placeholder => '请选择学生'}, :class => 'student-select'}
      )
    end
  end

  module ImageMethods
    def jimage(src, options = {})
      alt = options[:alt] || ''

      width = options[:width] || nil
      height = options[:height] || nil
      
      if !width.nil? && !height.nil?
        style = "width:#{width}px;height:#{height}px;"
      else
        style = ''
      end

      klass = options[:class] || ''
      klass = [klass, 'auto-fit-image'] * ' '

      content_tag :div, '', 
                  :class => klass, 
                  :style => style,
                  :'data-src' => src, 
                  :'data-alt' => alt, 
                  :'data-meta' => options[:'data-meta']
    end
  end

  module TimeMethods
    # TIME TZ
    def time_tz(time)
      time.strftime("%Y-%m-%dT%H:%M:%SZ")
    end
    
    def jtime(time)
      return content_tag(:span, '未知', :class=>'date') if time.blank?
      
      local_time = time.localtime
      content_tag(:span, _friendly_relative_time(local_time), :class=>'date', :'data-date'=>local_time.to_i)
    end

    def jtimeformat(time)
      time.localtime.strftime('%Y年%m月%d日 %H:%M')
    end

    private
      # 根据当前时间与time的间隔距离，返回时间的显示格式
      # 李飞编写
      def _friendly_relative_time(time)
        current_time = Time.now
        seconds = (current_time - time).to_i
        
        return '片刻前' if seconds < 0
        return "#{seconds}秒前" if seconds < 60        
        return "#{seconds/60}分钟前" if seconds < 3600
        return time.strftime('%H:%M') if seconds < 86400 && current_time.day == time.day
        return time.strftime("#{time.month}月#{time.day}日 %H:%M") if current_time.year == time.year
        return time.strftime("%Y年#{time.month}月#{time.day}日 %H:%M")
      end
  end

  module CommentMethods
    def comment_ct(comment)
      html_escape(comment.content).gsub(/\n/, '<br />').html_safe
    end

    def jcomments(model)
      render 'aj/comments', :model => model
    end
  end

  module FloatBoxMethods
    def jfbox(jfbox_id, title, options = {}, &block)
      width = options[:width] || 640
      height = options[:height] || 400

      style =
        'display:none;' +
        "width:#{width}px;" + 
        "height:#{height}px;" +
        "margin-left:-#{width/2}px;" +
        "margin-top:-#{height/2}px"

      tag_close = 
        content_tag :a, '×', 
                    :href => 'javascript:;',
                    :class => 'box-close'
      tag_title = 
        content_tag :div, title, 
                    :class => 'box-title'

      tag_body =
        content_tag :div, :class => 'box-body' do
          yield
        end

      content_tag :div, 
                  :'data-jfbox-id' => jfbox_id,
                  :class => "page-float-box #{jfbox_id}",
                  :style => style do
        tag_close + tag_title + tag_body
      end
    end

    def jfbox_link(jfbox_id, text, options ={})
      klass = ['page-float-box-link', options[:class]] * ' '

      link_to text, 'javascript:;', :class => klass,
                                    :'data-jfbox-id' => jfbox_id
    end
  end

  module UploadMethods

    def jupload_button(text)
      content_tag :div, :class => 'page-upload-button' do
        str1 = link_to text, 'javascript:;', :class => 'button'
        str2 = file_field_tag :file, :multiple => true
        str1 + str2
      end
    end

  end

  module TextMethods
    def jct(text)
      html_escape(text).gsub(/\n/, '<br />').html_safe
    end

    # 有时需要显示的文字为空，但又需要占位时，可以使用此方法
    def hspan(text, replace = '--')
      if text.blank?
        return content_tag :span, replace, :class => 'quiet'
      end
      return content_tag :span, text
    end

    def rich_text(text)
      text.html_safe
    end
  end

  module CourseMethods
    def course_name(course)
      return '未知课程' if course.blank?
      course.name
    end
  end

end
