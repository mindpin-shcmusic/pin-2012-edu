pie.load ->
  # 删除课程图片/视频
  jQuery(document).delegate '.page-course-show .images .link.delete a', 'click', ->
    $resource = jQuery(this).closest('.image')
    url = $resource.data('path')

    jQuery(this).confirm_dialog '确定要删除吗', ->
      jQuery.ajax
        url: url
        type: 'DELETE'
        success: (res)->
          $resource.fadeOut 400, ->
            $resource.remove()