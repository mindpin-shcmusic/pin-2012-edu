# 我的文件夹 -> 创建文件夹
pie.load ->
  jQuery(document).delegate '.page-create-doc-folder .form-submit-doc-button', 'click', ->
    $form = jQuery(this).closest('form')
    if pie.is_form_all_need_filled($form)
      url = $form.attr('action')
      data = $form.serialize()
      jQuery.ajax
        url: url
        type: 'POST'
        data: data
        success: (res)->
          $cells = jQuery(res).find('.cells')[0]
          jQuery('.page-model-list').prepend($cells)
          pie.close_fbox('create-upload-doc-folder')