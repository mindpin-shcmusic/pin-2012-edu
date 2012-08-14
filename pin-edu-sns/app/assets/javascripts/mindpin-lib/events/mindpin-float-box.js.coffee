# 浮动 box
# 配合 helper 方法 jfbox

pie.load ->
  jQuery(document).delegate 'a.page-float-box-link', 'click', ->
    jfbox_id = jQuery(this).data('jfbox-id')
    $box = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")

    pie.show_page_overlay()
    $box
      .delay(200).fadeIn(200)
      .trigger "mindpin:open-fbox"

  _close = ($box)->
    $box
      .fadeOut 200, ->
        pie.hide_page_overlay()
      .trigger "mindpin:close-fbox"

  jQuery(document).delegate '.page-float-box a.box-close', 'click', ->
    $box = jQuery(this).closest('.page-float-box')
    _close($box)

  pie.close_fbox = (jfbox_id)->
    $box = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")
    _close($box)