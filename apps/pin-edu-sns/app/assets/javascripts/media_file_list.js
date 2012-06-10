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

// 分类变体面包屑导航
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

  // jQuery('.next-level-categories a.category').live('click', function(){
  //   var url = jQuery(this).domdata('url');

  //   jQuery.ajax({
  //     url : url,
  //     beforeSend: function(xhr){
  //       xhr.setRequestHeader('X-PJAX', 'true')
  //     },
  //     success : function(data){
  //       jQuery('.page-content').html(data);
  //       history.pushState(null, jQuery(data).filter('title').text(), url);
  //     }
  //   })
  // });

})

// 点击列表项
pie.load(function(){
  // 打开一个 980x700 的浮动dom，使之垂直水平都居中
  // 并且随着 window resize 调整位置

  var _is_same_file = function(input_id, wrapper_elm){
    var last_loaded_id = wrapper_elm.domdata('last-loaded-id');
    wrapper_elm.domdata('last-loaded-id', input_id);    

    // TODO 如果上一次打开的是同一个文件，则不重新渲染
    
    return (input_id == last_loaded_id);
  }

  jQuery('.page-media-files a.media-file').live('click', function(){
    var id = jQuery(this).domdata('id');
    var wrapper_elm = jQuery('.page-media-file-show-wrapper');

    var is_same_file = _is_same_file(id, wrapper_elm);

    wrapper_elm
      .show();

    if(is_same_file){
      // TODO ...
      return;
    }

    var bd_elm = wrapper_elm.find('.bd');
    bd_elm.empty();

    var media_file_elm = jQuery(this).closest('.media-file');

    var creator_avatar_src = media_file_elm.domdata('creator-avatar-src');
    wrapper_elm.find('.avatar').html(jQuery('<img />').attr('src', creator_avatar_src));

    var title = media_file_elm.domdata('title');
    wrapper_elm.find('.title').html(title);

    var creator_name = media_file_elm.domdata('creator-name');
    wrapper_elm.find('.creator-name').html(creator_name);

    var uploaded_at = media_file_elm.domdata('uploaded-at');
    wrapper_elm.find('.uploaded-at').html(uploaded_at);

    jQuery.ajax({
      url  : '/media_files/' + id,
      type : 'GET',
      success : function(data){
        bd_elm.html(data);
      }
    })

  })

  jQuery('.page-media-file-show-wrapper a.close').live('click', function(){
    jQuery('.page-media-file-show-wrapper').hide();
  })
})