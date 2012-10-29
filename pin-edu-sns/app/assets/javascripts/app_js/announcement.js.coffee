pie.load ->
  jQuery(document).delegate '.page-admin-models.announcements a.remove', 'click', ->
    $announcement = jQuery(this).closest('.announcement')
    url = jQuery(this).data('url')

    jQuery(this).confirm_dialog '确定要删除吗', ->
      jQuery.ajax
        url: url
        type: 'DELETE'
        success: (res)->
          $announcement.fadeOut 400, ->
            $announcement.remove()