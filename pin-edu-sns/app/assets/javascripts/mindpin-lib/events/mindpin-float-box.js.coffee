# 浮动 box
# 配合 helper 方法 jfbox

pie.load ->
  jQuery(document).delegate 'a.page-float-box-link', 'click', ->
    jfbox_id = jQuery(this).data('jfbox-id')
    $box = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")

    pie.show_page_overlay()
    $box.delay(200).fadeIn(200)

    $box.trigger "mindpin:open-fbox"

  jQuery(document).delegate '.page-float-box a.box-close', 'click', ->
    $box = jQuery(this).closest('.page-float-box')

    $box.fadeOut 200, ->
      pie.hide_page_overlay()

    $box.trigger "mindpin:close-fbox"