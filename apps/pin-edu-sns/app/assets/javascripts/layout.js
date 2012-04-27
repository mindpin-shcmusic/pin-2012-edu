/*
 * @author ben7th
 * @useage 
 *   声明媒资系统的页面布局方法
 *   根据浏览器窗口宽度不同，自动转为6-4栏  
 */

pie.load(function(){
  var resize_container = function(){
    var max_width = jQuery(window).width();
    var container_elm = jQuery('.page-container');
    container_elm.removeClass('col5').removeClass('col4');

    if(max_width >= 1440){
      container_elm.addClass('col6');
    }else if(max_width >= 1200){
      container_elm.addClass('col5');
    }else{
      container_elm.addClass('col4');
    }

    container_elm.show();
  }

  resize_container();
  jQuery(window).resize(resize_container);

})