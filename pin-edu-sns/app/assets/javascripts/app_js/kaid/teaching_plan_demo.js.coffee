jQuery('.page-teaching-plan-show .chapter .publish a').click ->
  text = if jQuery(this).text() == '发布' then '不发布' else '发布'
  jQuery(this).text(text)

jQuery('.page-teaching-plan-show .chapters .create-button').click ->
  jQuery('.page-teaching-plan-show .chapters .blank').remove()
  jQuery('.page-teaching-plan-show .chapters :hidden').first().fadeIn()
