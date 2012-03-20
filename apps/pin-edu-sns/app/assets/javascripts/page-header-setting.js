// 用户设置的滑出菜单

jQuery(document).ready(function(){
  
  jQuery('.page-header .settings a.setting').click(function(){
    var elm = jQuery(this);
    var settings_elm = elm.closest('.settings');
    
    //关闭
    if(settings_elm.hasClass('open')){
      settings_elm
        //.animate({
        //  'width':79, 'height':50, 'opacity':1
        //}, 200) 改用HTML5
        .removeClass('open')
        //.find('ul.items')
        //  .hide()
        //.end()
      
      return;
    }
    
    //打开
    settings_elm
      //.animate({
      //  'width':200, 'height':175, 'opacity':0.9
      //}, 200) 改用HTML5
      .addClass('open')
      //.find('ul.items')
      //  .fadeIn()
      //.end()
  })
  
})
