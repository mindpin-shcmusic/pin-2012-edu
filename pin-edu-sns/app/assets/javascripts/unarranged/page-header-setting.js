// 用户设置的滑出菜单

jQuery(document).ready(function(){
  
  var close = function(){
    jQuery('.page-header .settings').removeClass('open'); // 用到了HTML5动画，改变class即可
    jQuery(document).unbind('click.page-header-setting');
  }
  
  var open = function(){
    jQuery('.page-header .settings').addClass('open'); // 用到了HTML5动画，改变class即可
    
    jQuery(document).bind('click.page-header-setting', function(evt){
      var target_elm = jQuery(evt.target);
      if(0 < target_elm.closest('.page-header .settings').length) return;
      // 在内部点击时，不触发关闭

      close();
    })
  }
  
  jQuery('.page-header .settings a.setting').click(function(){
    var elm = jQuery(this);
    var settings_elm = elm.closest('.settings');
    
    //关闭
    if(settings_elm.hasClass('open')){
      close();
      return;
    }
    
    //打开
    open();
  })
  
})
