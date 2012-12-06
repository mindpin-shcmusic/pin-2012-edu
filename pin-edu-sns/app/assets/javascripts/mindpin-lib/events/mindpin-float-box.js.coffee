# 浮动 box
# 配合 helper 方法 jfbox

pie.load ->
  _close = ($box)->
    $box
      .data('open', '')
      .fadeOut 200, ->
        pie.hide_page_overlay()
      .trigger 'mindpin:close-fbox'

  _open = ($box, $link)->
    return if $box.data('open') == 'opened'

    evt = jQuery.Event 'mindpin:open-fbox'
    evt.link_elm = $link
    evt.box_body = $box.find('.box-body')

    pie.show_page_overlay()
    $box
      .data('open', 'opened')
      .delay(200).fadeIn(200)
      .trigger evt    

  jQuery(document).delegate 'a.page-float-box-link', 'click', ->
    $link    = jQuery(this)
    jfbox_id = $link.data('jfbox-id')
    $box     = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")
    _open($box, $link)

  jQuery(document).delegate '.page-float-box a.box-close', 'click', ->
    $box = jQuery(this).closest('.page-float-box')
    _close($box)

  pie.close_fbox = (jfbox_id)->
    $box = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")
    _close($box)

  pie.open_fbox = (jfbox_id)->
    $box = jQuery(".page-float-box[data-jfbox-id=#{jfbox_id}]")
    _open($box)


  # 12月6日新增，一些扩展的通用事件
  # =====================================
  jQuery(document).delegate '.page-float-box .box-buttons a.ajax-cancel', 'click', ->
    $box = jQuery(this).closest('.page-float-box')
    _close($box)

  jQuery(document).delegate '.page-float-box .box-buttons a.ajax-submit', 'click', ->
    $box = jQuery(this).closest('.page-float-box')
    $form = jQuery(this).closest('form')
    url = $form.attr('action')

    if pie.is_form_all_need_filled($form)
      jQuery.ajax
        url: url
        type: 'POST'
        data: $form.serialize()
        success: (res)=>
          cells = jQuery(res).find('.cells')[0]
          jQuery('.page-model-list').prepend(cells)
          _close($box)
        error: (xhr)=>
          console.log(xhr.responseText)
