pie.load ->
  jQuery('.page-zhangjie-edit .editcontent').each ->
    $ele = jQuery(this)

    $edit = $ele.find('.edit')
    $content = $ele.find('.content')
    $form = $ele.find('.form')
    $form_content = $form.find('.form-content')
    $save = $form.find('.save')
    $cancel = $form.find('.cancel')

    $edit.click ->
      $edit.hide()
      $content.hide()
      $form_content.attr('value',$content.text())
      $form.show()

    $cancel.click ->
      $form.hide()
      $content.show()
      $edit.show()

    $save.click ->
      url = $form.data('url')
      jQuery.ajax
        url: url
        type: 'POST'
        data:
          content: $form_content.attr('value') 
        success: (res)->
          $content.text(res)
          $form.hide()
          $content.show()
          $edit.show()
