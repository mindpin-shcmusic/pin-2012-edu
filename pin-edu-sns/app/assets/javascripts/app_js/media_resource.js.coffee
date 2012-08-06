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


# jQuery ->
#   jQuery('.page-media-resource-list .media-resource a.put-public').live 'click', ->
#     elm = jQuery(this)
#     id = elm.data('id')

#     jQuery.ajax({
#       type: 'POST',
#       url : '/public_resources/share/',
#       data: {resource_id: id},
#       success : ->
#         elm.remove()
#     })