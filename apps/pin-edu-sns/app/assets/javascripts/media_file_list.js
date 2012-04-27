/*
 * @author ben7th
 * @useage 
 *   声明媒体资源列表的lazyload，自动加载，以及交互行为
 */

// 列表lazyload
pie.load(function(){
  var list_elm = jQuery('.page-media-files');
  if(0 == list_elm.length) return;


  var lazy_load = function(){
    pie.log(111)
    list_elm.find('.media-file .cover:not(.-img-loaded-)').each(function(){
      var elm = jQuery(this);
      if(elm.is_in_screen()){
        pie.load_box_img(elm);
        elm.addClass('-img-loaded-')
      }
    });
  }

  lazy_load();
  jQuery(window).bind('scroll', lazy_load);
})