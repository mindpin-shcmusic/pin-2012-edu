pie.load ->
  return if !jQuery('.page-zhangjie-edit .editcontent').exists()

  add_editcontent_event = ->
    jQuery('.page-zhangjie-edit .editcontent').each ->
      $ele = jQuery(this)
      return if $ele.data('loaded')
      $ele.data('loaded',true)

      $edit = $ele.find('.edit')
      $content = $ele.find('.content')
      $form = $ele.find('.form')
      $form_content = $form.find('.form-content')
      $save = $form.find('.save')
      $cancel = $form.find('.cancel')

      $edit.on 'click', ->
        $edit.hide()
        $content.hide()
        $form_content.attr('value',$content.text())
        $form.show()

      $cancel.on 'click', ->
        $form.hide()
        $content.show()
        $edit.show()

      $save.on 'click', ->
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

  add_editcontent_event()
  jQuery(document).on('chapter:add_course_ware',add_editcontent_event)

pie.load ->
  $tabs = jQuery('.page-zhangjie-edit .desc-info .tabs')
  $navs = $tabs.find('.navs')
  $contents = $tabs.find('> .contents')
  $add = $navs.find('> .add')
  url = $add.data('url')
  $add.on 'click', ->
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
        jQuery(document).trigger('chapter:add_course_ware')

# 从资源盘选取资源到课件
pie.load ->
  return if !jQuery('.page-zhangjie-edit .desc-info').exists()

  add_kejian_file_event = ->
    jQuery('.page-zhangjie-edit .kejian-file').each ->
      $ele = jQuery(this)
      return if $ele.data('loaded')
      $ele.data('loaded',true)
      course_ware_id = $ele.data('course_ware_id')

      # 资源树
      $dynatree = $ele.find('.dynatree')
      $dynatree.dynatree
        debugLevel: 0
        children: $dynatree.data('children')


      $submit = $ele.find('.page-float-box .select-submit')
      jfbox_id = $submit.closest('.page-float-box').data('jfbox-id')
      $submit.on 'click', ->
        $node = $dynatree.dynatree("getActiveNode")
        if !$node.data.isFolder
          jQuery.ajax
            url: "/course_wares/#{course_ware_id}/link_file"
            type: 'PUT'
            data:
              media_resource_id: $node.data.id
            success: (res)->
              $ele.find('> .file').html(res)
              pie.close_fbox(jfbox_id)

  add_kejian_file_event()
  jQuery(document).on('chapter:add_course_ware',add_kejian_file_event)
