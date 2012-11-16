pie.load ->
  jQuery(document).delegate '.page-list-head .headtop .buttons a.button.batch-destroy', 'click', ->
    # 获取ids和model
    model = jQuery(this).data('model')

    ids = []
    jQuery('.page-model-list .cell.checkbox .c.checked').each ->
      id = jQuery(this).closest('.cell.checkbox').data('model-id')
      ids.push id

    jQuery(this).confirm_dialog '确定要删除吗？', ->
      jQuery.ajax
        url: '/batch_destroy'
        type: 'delete'
        data:
          model: model
          ids: ids.join(',')
        success: ->
          location.reload()