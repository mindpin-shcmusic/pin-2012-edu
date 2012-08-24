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
  jQuery(document).on('ajax:create-resource', lazy_load)

# 点击列表项
pie.load ->
  $dynatree = jQuery('.page-float-box[data-jfbox-id=move_dir] .dynatree')

  reload_dynatree = () ->
    console.log('reload dynatree')
    pie.dont_show_loading_bar()
    jQuery.ajax
      url: '/media_resources/reload_dynatree'
      type: 'GET'
      data:
        dir: $dynatree.data('current_dir')
      success:(res)->
        tree = $dynatree.dynatree('getTree')
        tree.options.children = res
        tree.reload()

  # 从服务端请求数据，重新设置 dynatree
  # 这个目录树是当前页面所有资源共享的，涉及到两个问题
  # 1 点开每一个资源的移动目录窗口时，如果当前资源是目录，需要隐藏掉其子目录
  #   所以每次让目录树重置，是一个相对简单的处理方式，如果需要在细化
  # 2 每次打开移动目录窗口时，目录树中被选中是当前页面对应的目录会体验好一些
  # 所以针对这两个问题，重新设置是最简单的处理方式
  jQuery(document).on('ajax:create-folder', reload_dynatree)
  jQuery(document).on('ajax:delete-folder', reload_dynatree)
  jQuery('.page-float-box[data-jfbox-id=move_dir]').on('mindpin:close-fbox', reload_dynatree)

  # delete
  jQuery(document).delegate '.page-media-resources .media-resource .link.delete a', 'click', ->
    $resource = jQuery(this).closest('.media-resource')
    path = $resource.data('path')
    url = "/file#{path}"

    jQuery(this).confirm_dialog '确定要删除吗', ->
      jQuery.ajax
        url: url
        type: 'DELETE'
        success: (res)->
          jQuery(document).trigger('ajax:delete-folder')
          $resource.fadeOut 400, ->
            $resource.remove()


  # 移动目录
  $dynatree.dynatree
    debugLevel: 0
    children: $dynatree.data('children')
    onLazyRead:(node)->
      node.appendAjax
        url: '/media_resources/lazyload_sub_dynatree'
        type: 'GET'
        data:
          parent_dir: node.data.dir
          current_resource_path: $dynatree.data('current_resource_path')

  # 打开移动目录窗口时，记录当前要移动的资源
  jQuery(document).delegate '.page-float-box[data-jfbox-id=move_dir]','mindpin:open-fbox',(evt)->
    current_resource_path = evt.link_elm.closest('.media-resource').data('path')
    $dynatree.data('current_resource_path', current_resource_path)

  jQuery(document).delegate '.page-float-box[data-jfbox-id=move_dir] .submit-selected-dir','click',->
    selected_dir_node = $dynatree.dynatree('getActiveNode')
    selected_dir = selected_dir_node.data.dir
    current_resource_path = $dynatree.data('current_resource_path')

    if selected_dir != current_resource_path
      jQuery.ajax
        url: '/media_resources/move'
        type: 'PUT'
        data:
          current_resource_path: current_resource_path
          to_dir: selected_dir
        success:(res)->
          window.location = res
        error:(jqXHR, textStatus)->
          if jqXHR.status == 422
            alert(jqXHR.responseText)
    else
      alert('不能将文件移动到自身或其子目录下')
