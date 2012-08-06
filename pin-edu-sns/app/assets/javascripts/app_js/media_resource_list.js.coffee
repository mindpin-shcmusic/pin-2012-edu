# @author ben7th （fushang318 略微修改）
# @useage 声明媒体资源列表的lazyload，自动加载，以及交互行为

# 列表lazyload
pie.load ->
  lazy_load = ->
    jQuery('.page-media-resources .media-resource .cover:not(.-img-loaded-)').each ->
      $cover = jQuery(this)

      if $cover.is_in_screen()
        $cover.load_fit_image()
        $cover.addClass('-img-loaded-')

  lazy_load()

  jQuery(window).bind('scroll', lazy_load)
  jQuery(document).on('pjax:complete', lazy_load)
  jQuery(document).on('ajax:create-folder', lazy_load)

# 点击列表项
pie.load ->
  
  # delete
  jQuery(document).delegate '.page-media-resources .media-resource .link.delete a', 'click', ->
    $resource = jQuery(this).closest('.media-resource')
    url = $resource.data('resource-url')

    jQuery(this).confirm_dialog '确定要删除吗', ->
      jQuery.ajax
        url: url
        type: 'DELETE'
        success: (res)->
          $resource.fadeOut 400, ->
            $resource.remove()