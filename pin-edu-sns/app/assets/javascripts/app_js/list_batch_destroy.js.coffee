pie.load ->
  jQuery(document).delegate '.page-list-head .headtop .buttons a.button.batch-destroy', 'click', ->
    # 获取ids和model
    model = jQuery(this).data('model')

    # ids = []
    # jQuery('.page-model-list .cell.checkbox .c.checked').each ->
    #   id = jQuery(this).

    console.log(model)

    jQuery(this).confirm_dialog '确定要删除吗？', ->