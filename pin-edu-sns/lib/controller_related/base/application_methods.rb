module ApplicationMethods
  def self.included(base)
    # 拦截ie6的访问
    base.before_filter :hold_ie678
    # 捕捉一些特定异常
    # base.around_filter :catch_some_exception 开发时先注掉了
    # 修正IE浏览器请求头问题
    base.before_filter :fix_ie_accept
    # 对错误显示友好的页面
    base.around_filter :catch_template_exception
  end

  #-----------------------
  
  def render_status_page(code, text = '')
    @status_code = code.to_i
    @status_text = text.to_s
    render "layouts/status_page/status_page", :status=>@status_code, :layout => false
  end

  #----------------------

  def hold_ie678
    return if params[:controller] == 'file_entities' && params[:action] == 'download'
    
    if /MSIE 6/.match(request.user_agent)
      render "layouts/status_page/hold_ie678",:layout=>false
    end

    if /MSIE 7/.match(request.user_agent)
      render "layouts/status_page/hold_ie678",:layout=>false
    end

    if /MSIE 8/.match(request.user_agent)
      render "layouts/status_page/hold_ie678",:layout=>false
    end
  end

  def catch_some_exception
    yield
  rescue ActiveRecord::RecordNotFound
    render_status_page(404,"正在访问的页面不存在，或者已被删除。")
  rescue Exception => e
    if Rails.env.production?
      return render_status_page(500,e.message)
    else
      raise e
    end
  end

  def fix_ie_accept
    if /MSIE/.match(request.user_agent) && request.env["HTTP_ACCEPT"]!='*/*'
      if !/.*\.gif/.match(request.url)
        request.env["HTTP_ACCEPT"] = '*/*'
      end
    end
  end

  def catch_template_exception
    yield
  rescue ActionView::TemplateError=>ex
    p ex.message
    puts ex.backtrace*"\n"
    if Rails.env.development?
      raise ex
    else
      return render_status_page(500,ex.message)
    end
  end

  def is_android_client?
    request.headers["User-Agent"] == "android"
  end

end
