pie.load ->
  $list_selector_box = jQuery('.page-float-box-list-selector')
  $list_selector = $list_selector_box.find('.list-selector')

  if $list_selector_box.exists()
    $jfbox_link = $list_selector_box.find('.page-float-box-link[data-jfbox-id=courses]')
    $jfbox = $list_selector_box.find('.page-float-box[data-jfbox-id=courses]')

    $list_selector_box.find('.submit-fbox').on 'click', ->
      ids = $list_selector.data('list_selector').get_selected_ids()
      $jfbox_link.data('ids',ids)
      pie.close_fbox('courses')

    $list_selector_box.find('.close-fbox').on 'click', ->
      pie.close_fbox('courses')

    $jfbox.on 'mindpin:open-fbox', ->

    $jfbox.on 'mindpin:close-fbox', ->
      selector = $list_selector.data('list_selector')
      ids = $jfbox_link.data('ids')
      ui_ids = selector.get_selected_ids()
      if ids != undefined && ids != ui_ids
        selector.set_selected_ids(ids)
      $jfbox_link.text("已选择了#{ids.length}个")
