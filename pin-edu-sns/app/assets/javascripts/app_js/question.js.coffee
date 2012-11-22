pie.load ->
  # 显示编辑
  jQuery(document).delegate '.page-model-show .field .link.edit a', 'click', ->
    jQuery('.page-edit-form').removeClass('hide')
