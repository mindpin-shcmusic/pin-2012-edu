pie.load ->
  # 显示编辑
  jQuery(document).delegate '.page-question-show .field .link.edit a', 'click', ->
    jQuery('.page-question-show .page-edit-form').removeClass('hide')
