# 我的文件夹 -> 创建文件夹
pie.load ->
  $box = jQuery('.page-create-folder-box')

  jQuery(document).delegate '.page-media-resource-head a.create-folder-button', 'click', ->
    default_name = $box.data('default-name')
    pie.show_page_overlay()
    $box
      .delay(200).fadeIn(200)
      .find('form input[name=folder]').val(default_name)

  jQuery(document).delegate '.page-create-folder-box .form-cancel-button', 'click', ->
    $box.fadeOut 200, ->
      pie.hide_page_overlay()

  jQuery(document).delegate '.page-create-folder-box .form-submit-button', 'click', ->
    $form = $box.find('form')
    if pie.is_form_all_need_filled($form)
      url = $form.attr('action')
      data = $form.serialize()
      jQuery.ajax
        url: url
        type: 'POST'
        data: data
        success: (res)->
          $list = jQuery('.page-media-resources')
          $list.prepend jQuery(res).find('.media-resource')
          jQuery(document).trigger('ajax:create-folder')

          $box.fadeOut 200, ->
            pie.hide_page_overlay()

# 资源查看 -> 分享资源到公共资源库
pie.load ->
  $public_resource = jQuery('.page-media-resource .share-state .public-resource')
  $dynatree = jQuery('.page-media-resource .share-state .public-resource .page-float-box[data-jfbox-id=set_category] .dynatree')

  $dynatree.dynatree
    debugLevel: 0
    children: $dynatree.data('children')
    onLazyRead:(node)->
      node.appendAjax
        tyle: 'GET'
        url: "/categories/#{node.data.id}/lazyload_sub_dynatree"

  jQuery(document).delegate '.page-media-resource .share-state .public-resource .submit-selected-category', 'click', ->
    $node = $dynatree.dynatree("getActiveNode")
    if $node.data.id == $public_resource.data('category_id')
      pie.close_fbox("set_category")
      return 

    jQuery.ajax
      type: 'POST'
      url: $public_resource.data('share_url')
      data:
        category_id: $node.data.id
      success:(res)=>
        $public_resource.addClass("added").removeClass("unadd").end()
        $public_resource.data('category_id',$node.data.id)
        pie.close_fbox("set_category")

  jQuery(document).delegate '.page-float-box[data-jfbox-id=set_category]','mindpin:close-fbox',->
    select_id = $dynatree.dynatree("getActiveNode").data.id
    if select_id != $public_resource.data('category_id')
      node_of_belongs_category = $dynatree.dynatree('getTree').getNodeByKey($public_resource.data('category_id'))
      if !!node_of_belongs_category
        node_of_belongs_category.activate()
      else
        $dynatree.dynatree('getTree').reload()
