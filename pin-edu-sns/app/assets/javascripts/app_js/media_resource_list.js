/*
 * @author ben7th （fushang318 略微修改）
 * @useage 声明媒体资源列表的lazyload，自动加载，以及交互行为
 */

// 列表lazyload
pie.load(function(){
  var lazy_load = function(){
    jQuery('.page-media-resources .media-resource .cover:not(.-img-loaded-)').each(function(){
      var elm = jQuery(this);
      if(elm.is_in_screen()){
        elm.load_fit_image();
        elm.addClass('-img-loaded-')
      }
    });
  }

  lazy_load();
  jQuery(window).bind('scroll', lazy_load);
  jQuery(document).on('pjax:complete', lazy_load);
  jQuery(document).on('ajax:create-folder', lazy_load);
})

// 点击列表项
pie.load(function(){
  // 打开一个 980x700 的浮动dom，使之垂直水平都居中
  // 并且随着 window resize 调整位置

  var _is_same_file = function(input_id, wrapper_elm){
    var last_loaded_id = wrapper_elm.data('last-loaded-id');
    wrapper_elm.data('last-loaded-id', input_id);    

    // TODO 如果上一次打开的是同一个文件，则不重新渲染
    
    return (input_id == last_loaded_id);
  }

  jQuery('.page-media-resources a.media-resource').live('click', function(){
    var is_dir = jQuery(this).data('is-dir');
    var resource_url = jQuery(this).data('resource-url');
    if(is_dir){
      window.location = resource_url;
      return;
    }

    var id = jQuery(this).data('id');
    var wrapper_elm = jQuery('.page-media-resource-show-wrapper');

    var is_same_file = _is_same_file(id, wrapper_elm);

    wrapper_elm
      .show();

    if(is_same_file){
      // TODO ...
      return;
    }

    var bd_elm = wrapper_elm.find('.bd');
    bd_elm.empty();

    var media_resource_elm = jQuery(this).closest('.media-resource');

    var creator_avatar_src = media_resource_elm.data('creator-avatar-src');
    wrapper_elm.find('.avatar').html(jQuery('<img />').attr('src', creator_avatar_src));

    var title = media_resource_elm.data('title');
    wrapper_elm.find('.title').html(title);

    var creator_name = media_resource_elm.data('creator-name');
    wrapper_elm.find('.creator-name').html(creator_name);

    var uploaded_at = media_resource_elm.data('uploaded-at');
    wrapper_elm.find('.uploaded-at').html(uploaded_at);

    jQuery.ajax({
      url  : '/media_resources/' + id,
      type : 'GET',
      success : function(data){
        bd_elm.html(data);
      }
    })

  })

  jQuery('.page-media-resource-show-wrapper a.close').live('click', function(){
    jQuery('.page-media-resource-show-wrapper').hide();
  })
})