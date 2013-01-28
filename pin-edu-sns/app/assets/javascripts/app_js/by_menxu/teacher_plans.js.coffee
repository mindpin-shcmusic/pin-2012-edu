pie.load ->
  $create_button = jQuery('.page-teaching-plan-show .chapters .btns .create-button a')
  $chapters = jQuery('.page-teaching-plan-show .chapters .chs')
  $blank = $chapters.parent().find('.blank')
  $chapter_destroy = $chapters.find('.chapter .items .remove a')
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
    console.log id
    console.log $course_ware_contents.find('.current').removeClass('current')
    console.log $course_ware_contents.find("[data-cw-id=#{id}]").addClass('current')