# @author ben7th
# @useage 声明媒资系统登录页面的前端行为

# 登录页面背景
pie.load ->
  $wallpaper_box = jQuery('body.auth .page-wallpaper')
  if $wallpaper_box.exists()
    $wallpaper_box.load_fit_image()
    jQuery(window).resize ->
      $wallpaper_box.resize_fit_image()

# 登录表单事件
pie.load ->
  $login_form = jQuery('.page-login form')
  if $login_form.exists()
    # ajax
    $login_form.find('a.form-submit-ajax-button').click ->
      action = $login_form.attr('action')
      params = $login_form.serialize()

      jQuery.ajax
        url  : action
        type : 'POST'
        data : params
        dataType : 'json'
        success: (res)->
          window.location.href = res.redirect_to
        error: (xhr)->
          $login_form.find('.login-errors')
            .stop()
            .empty().html(xhr.responseText)
            .fadeIn().delay(3000).fadeOut()