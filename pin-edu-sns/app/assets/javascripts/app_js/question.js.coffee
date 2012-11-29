pie.load ->
  # 显示编辑
  jQuery(document).delegate '.page-model-show.question .edit-answer a', 'click', ->
    jQuery('.page-model-show.question .page-edit-form').removeClass('hide')
