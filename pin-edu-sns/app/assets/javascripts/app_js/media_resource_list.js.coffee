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

  # 移动目录
  $dynatree = jQuery('.page-float-box[data-jfbox-id=move_dir] .dynatree')
  $dynatree.dynatree
    children: $dynatree.data('children')
    onLazyRead:(node)->
      node.appendAjax
        url: '/media_resources/lazyload_sub_dynatree'
        type: 'GET'
        data:
          parent_media_resource_id: node.data.id
          move_media_resource_id: $dynatree.data('move_media_resource_id')

  # 打开移动目录窗口时，记录当前要移动的资源
  jQuery(document).delegate '.page-float-box[data-jfbox-id=move_dir]','mindpin:open-fbox',(evt)->
    move_media_resource_id = evt.link_elm.closest('.media-resource').data('id')
    $dynatree.data('move_media_resource_id',move_media_resource_id)

  # 关闭移动目录窗口时，还原 dynatree 为初始化的状态
  # 这个目录树是当前页面所有资源共享的，涉及到两个问题
  # 1 点开每一个资源的移动目录窗口时，如果当前资源是目录，需要隐藏掉其子目录
  #   所以每次让目录树重置，是一个相对简单的处理方式，如果需要在细化
  # 2 每次打开移动目录窗口时，目录树中被选中是当前页面对应的目录会体验好一些
  # 所以针对这两个问题，重置是最简单的处理方式
  jQuery(document).delegate '.page-float-box[data-jfbox-id=move_dir]','mindpin:close-fbox',->
    $dynatree.dynatree('getTree').reload()

  jQuery(document).delegate '.page-float-box[data-jfbox-id=move_dir] .submit-selected-dir','click',->
    active_media_resource_id = $dynatree.dynatree('getActiveNode').data.id
    move_media_resource_id = $dynatree.data('move_media_resource_id')
    if active_media_resource_id != move_media_resource_id
      jQuery.ajax
        url: '/media_resources/move'
        type: 'PUT'
        data:
          media_resource_id: move_media_resource_id
          to_dir_id: active_media_resource_id
        success:(res)->
          window.location = "/file#{res}"
    else
      alert("不能移动到自己")
  
