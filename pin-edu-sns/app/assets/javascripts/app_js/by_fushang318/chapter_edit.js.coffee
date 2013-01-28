pie.load ->
  jQuery('.page-zhangjie-edit .editcontent').each ->
    $ele = jQuery(this)

    $edit = $ele.find('.edit')
    $content = $ele.find('.content')
    $form = $ele.find('.form')
    $form_content = $form.find('.form-content')
    $save = $form.find('.save')
    $cancel = $form.find('.cancel')

    $edit.live 'click', ->
      $edit.hide()
      $content.hide()
      $form_content.attr('value',$content.text())
      $form.show()

    $cancel.live 'click', ->
      $form.hide()
      $content.show()
      $edit.show()

    $save.live 'click', ->
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


pie.load ->
  $tabs = jQuery('.page-zhangjie-edit .desc-info .tabs')
  $navs = $tabs.find('.navs')
  $contents = $tabs.find('> .contents')
  $add = $navs.find('> .add')
  url = $add.data('url')
  $add.click ->
    jQuery.ajax
      url: url
      type: 'POST'
      success: (res)->
        $content = jQuery("<div class='content'></div>")
        $content.append(res)
        $contents.append($content)

        $nav = jQuery("<a class='nav' href='javascript:void(0);'></a>")
        count = $tabs.find('.navs .nav').length
        $nav.text(count+1)
        $add.before($nav)
