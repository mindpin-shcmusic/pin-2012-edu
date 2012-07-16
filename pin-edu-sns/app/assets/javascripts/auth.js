/*
 * @author ben7th
 * @useage 
 *   声明媒资系统登录页面的前端行为
 */

// 登录页面背景
pie.load(function(){
  var wallpaper_box_elm = jQuery('body.auth .page-wallpaper');
  if(0 == wallpaper_box_elm.length) return;
  
  pie.load_box_img(wallpaper_box_elm);
  jQuery(window).resize(function(){
    pie.resize_box_img(wallpaper_box_elm);
  });
})

// 登录表单事件
pie.load(function(){
  var login_form_elm = jQuery('.page-login form');
  if(0 == login_form_elm.length) return;

  login_form_elm
    .find('input[type=text], input[type=password]')
      .val('')
      .focus(function(){
        var elm = jQuery(this);
        var label_elm = jQuery();
      })
      .pie_j_tips();

  // ajax
  login_form_elm.find('a.form-submit-ajax-button').click(function(){
    var action = login_form_elm.attr('action');
    var params = login_form_elm.serialize();

    jQuery.ajax({
      url  : action,
      type : 'POST',
      data : params,
      dataType : 'json',
      success : function(res){
        var redirect_to = res.redirect_to;
        window.location.href = redirect_to;
      },
      error : function(xhr){
        login_form_elm.find('.login-errors')
          .stop()
          .empty().html(xhr.responseText)
          .fadeIn().delay(3000).fadeOut();
      }
    })
  })
})