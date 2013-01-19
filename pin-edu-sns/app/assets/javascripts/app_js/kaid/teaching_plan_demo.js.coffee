jQuery('.page-teaching-plan-show.page-model-show .chapter').hide()

jQuery('.page-teaching-plan-show.page-model-show .chapter .publish a').click ->
  text = if jQuery(this).text() == '发布' then '不发布' else '发布'
  jQuery(this).text(text)

jQuery('.page-teaching-plan-show.page-model-show .chapters .create-button').click ->
  jQuery('.page-teaching-plan-show.page-model-show .chapters .blank').hide()
  jQuery('.page-teaching-plan-show.page-model-show .chapters :hidden').first().fadeIn()