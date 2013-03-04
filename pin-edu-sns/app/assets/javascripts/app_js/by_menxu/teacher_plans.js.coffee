pie.load ->
  $create_button = jQuery('.page-teaching-plan-show .chapters .btns .create-button a')
  $chapters = jQuery('.page-teaching-plan-show .chapters .chs')
  $chapter_destroy = $chapters.find('.chapter .items .remove a')
  $blank = $chapters.parent().find('.blank')
  $course_ware_title = jQuery('.page-fangan-review .preview .navs.titles .title')
  $course_ware_contents = jQuery('.page-fangan-review .preview .contents')


  $create_button.on 'click', ->
    jQuery.ajax
      url: $create_button.data 'url'
      type: 'POST'
      success: (res) ->
        $res = jQuery(res).hide()
        $chapters.append $res
        $blank.fadeOut()
        $res.fadeIn()

  jQuery(document).on 'click', $chapter_destroy.selector, ->
    $self = jQuery(this)
    $chapter = $self.closest('.chapter')
    jQuery.ajax
      url: $self.data('url')
      type: 'DELETE'
      success: (res) ->
        $chapter.fadeOut ->
          $chapter.remove()
          $blank.fadeIn() if $chapters.children().length == 0

  $course_ware_title.on 'click', ->
    id = jQuery(this).data('cw-id')
    $course_ware_contents.find('.current').removeClass('current')
    $course_ware_contents.find("[data-cw-id=#{id}]").addClass('current')

  # 删除教学方案
  jQuery(document).delegate '.plans .item a.remove', 'click', ->
    $resource = jQuery(this).closest('.item')
    url = $resource.data('path')

    jQuery(this).confirm_dialog '确定要删除吗', ->
      jQuery.ajax
        url: url
        type: 'DELETE'
        success: (res)->
          $resource.fadeOut 400, ->
            $resource.remove()
