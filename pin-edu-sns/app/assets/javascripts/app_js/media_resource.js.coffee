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


# 我的文件夹 -> 上传文件
pie.load ->
  $upload_box = jQuery('.page-upload-box')

  jQuery(document).delegate '.page-media-resource-head a.upload-file-button', 'click', ->
    pie.show_page_overlay()
    $uploader = jQuery('.page-media-file-uploader')
    $upload_box.delay(200).fadeIn(200)

  jQuery(document).delegate '.page-upload-box a.form-cancel-button', 'click', ->
    $upload_box.fadeOut 200, ->
      pie.hide_page_overlay()

# 资源查看 -> 分享资源到公共资源库
pie.load ->
  $public_resource = jQuery('.page-media-resource .share-state .public-resource')
  jQuery(document).delegate '.page-float-box[data-jfbox-id=set_category]', 'mindpin:open-fbox', ->
    if "" == jQuery('.dynatree').text()
      jQuery.ajax
        type: 'GET'
        url : $public_resource.data('categories_url')
        success: (res)=>
          console.log(res)
          jQuery('.dynatree').dynatree
            children: res

  jQuery(document).delegate '.page-media-resource .share-state .public-resource .submit-selected-category', 'click', ->
    $node = jQuery('.dynatree').dynatree("getActiveNode")
    if null != $node
      jQuery.ajax
        type: 'POST'
        url: $public_resource.data('share_url')
        data:
          category_id: $node.data.id
        success:(res)=>
          $public_resource.addClass("added").removeClass("unadd").end()
          pie.close_fbox("set_category")
