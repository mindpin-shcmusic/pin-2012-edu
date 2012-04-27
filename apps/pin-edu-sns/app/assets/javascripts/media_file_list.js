/*
 * @author ben7th
 * @useage 声明媒体资源列表的lazyload，自动加载，以及交互行为
 */

// 列表lazyload
pie.load(function(){
  var lazy_load = function(){
    //pie.log('LAZY LOAD');
    //pie.log(jQuery('.page-media-files').find('.media-file .cover:not(.-img-loaded-)'));

    jQuery('.page-media-files .media-file .cover:not(.-img-loaded-)').each(function(){
      var elm = jQuery(this);
      if(elm.is_in_screen()){
        pie.load_box_img(elm);
        elm.addClass('-img-loaded-')
      }
    });
  }

  lazy_load();
  jQuery(window).bind('scroll', lazy_load);
  jQuery(document).on('pjax:complete', lazy_load);
})

pie.load(function(){

  jQuery('.breadcrumb-categories a.category').live('click', function(){
    var url = jQuery(this).domdata('url');

    jQuery.ajax({
      url : url,
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-PJAX', 'true')
      },
      success : function(data){
        jQuery('.page-content').html(data);
        history.pushState(null, jQuery(data).filter('title').text(), url);
      }
    })
  });

  jQuery('.next-level-categories a.category').live('click', function(){
    var url = jQuery(this).domdata('url');

    jQuery.ajax({
      url : url,
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-PJAX', 'true')
      },
      success : function(data){
        jQuery('.page-content').html(data);
        history.pushState(null, jQuery(data).filter('title').text(), url);
      }
    })
  });

})

// 点击列表项
pie.load(function(){
  jQuery('.page-media-files a.media-file[data-kind=video]').live('click', function(){
    location.href = '/media_files/' + jQuery(this).domdata('id');
  })
})