# 我的文件夹 -> 创建文件夹
pie.load ->
  $box = jQuery('.page-create-folder-box')

  jQuery(document).delegate '.page-fixed-head a.create-folder-button', 'click', ->
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
          $list = jQuery('.page-upload-document-dirs')
          $list.prepend jQuery(res).find('.media-resource')
          jQuery(document).trigger('ajax:create-folder')

          $box.fadeOut 200, ->
            pie.hide_page_overlay()


