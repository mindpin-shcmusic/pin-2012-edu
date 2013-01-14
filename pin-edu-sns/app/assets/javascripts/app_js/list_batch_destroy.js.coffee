pie.load ->
  jQuery(document).delegate '.page-top-fixed.list-head .headtop .buttons a.button.batch-destroy', 'click', ->
    # 获取ids和model
    model = jQuery(this).data('model')

    ids = []
    jQuery('.page-model-list .cell.checkbox .c.checked').each ->
      id = jQuery(this).closest('.cell.checkbox').data('model-id')
      ids.push id

    jQuery(this).confirm_dialog '确定要删除吗？', ->
      jQuery.ajax
        url: '/batch_destroy'
        type: 'POST'
        data:
          model: model
          ids: ids.join(',')
        success: ->
          location.reload()

  # 点击全选，全部选中
  jQuery(document).delegate '.page-top-fixed.list-head .cell.checkbox span.c', 'click', ->
    $span = jQuery(this)

    if $span.hasClass('checked')
      # 取消选中
      # 选中
      jQuery('.page-model-list .cell.checkbox span.c').each ->
        jQuery(this).removeClass('checked')
        jQuery(this).find('input[type=checkbox]').attr('checked', false)
    else
      # 选中
      jQuery('.page-model-list .cell.checkbox span.c').each ->
        jQuery(this).addClass('checked')
        jQuery(this).find('input[type=checkbox]').attr('checked', true)

  jQuery(document).delegate '.page-model-list .cell.checkbox span.c', 'click', ->
    $span = jQuery(this)
    if $span.hasClass('checked')
      jQuery('.page-list-head .cell.checkbox span.c').removeClass('checked')
      jQuery('.page-list-head .cell.checkbox span.c').find('input[type=checkbox]').attr('checked', false)

