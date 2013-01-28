pie.load ->
  $create_button = jQuery('.page-teaching-plan-show .chapters .btns .create-button a')
  $chapters = jQuery('.page-teaching-plan-show .chapters .chs')
  $chapter_destroy = $chapters.find('.chapter .items .remove a')

  $create_button.on 'click', ->
    jQuery.ajax
      url: $create_button.data 'url'
      type: 'POST'
      success: (res) ->
        $res = jQuery(res).hide()
        $chapters.append $res
        $chapters.parent().find('.blank').fadeOut()
        $res.fadeIn()


  jQuery(document).on 'click', $chapter_destroy.selector, ->
    $self = jQuery(this)
    $chapter = $self.closest('.chapter')
    jQuery.ajax
      url: $self.data('url')
      type: 'DELETE'
      success: (res) ->
        $chapter.fadeOut()




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

 
