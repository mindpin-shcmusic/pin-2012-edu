pie.load ->
  jQuery('.page-float-box-list-selector').each ->
    $list_selector_float_box = jQuery(this)

    $list_selector = $list_selector_float_box.find('.list-selector')

    $jfbox_link = $list_selector_float_box.find('.page-float-box-link[data-jfbox-id]')
    $jfbox = $list_selector_float_box.find('.page-float-box[data-jfbox-id]')

    jfbox_id = $jfbox_link.attr('data-jfbox-id')

    $list_selector_float_box.find('.submit-fbox').on 'click', ->
      ids = $list_selector.data('list_selector').get_selected_ids()
      $jfbox_link.data('ids',ids)
      pie.close_fbox(jfbox_id)

    $list_selector_float_box.find('.close-fbox').on 'click', ->
      pie.close_fbox(jfbox_id)

    $jfbox.on 'mindpin:open-fbox', ->
      ids = $jfbox_link.data('ids')
      if ids == undefined
        ids = $list_selector.data('list_selector').get_selected_ids()
        $jfbox_link.data('ids',ids)

    $jfbox.on 'mindpin:close-fbox', ->
      selector = $list_selector.data('list_selector')
      ids = $jfbox_link.data('ids') || []
      ui_ids = selector.get_selected_ids()
      if ids != ui_ids
        selector.set_selected_ids(ids)
        $jfbox_link.text("已选择了#{ids.length}个")
