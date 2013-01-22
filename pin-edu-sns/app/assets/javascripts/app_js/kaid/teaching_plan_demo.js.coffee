jQuery('.page-teaching-plan-show .chapter .publish a').click ->
  is_published = jQuery(this).text() == '取消'
  if is_published
    jQuery(this).text('发布')
    jQuery(this).closest('.publish').find('.status').text('未发布')
  else
    jQuery(this).text('取消')
    jQuery(this).closest('.publish').find('.status').text('已发布')
  
jQuery('.page-teaching-plan-show .chapters .create-button').click ->
  jQuery('.page-teaching-plan-show .chapters .blank').remove()

  jQuery('.page-teaching-plan-show .chapters .chapter:hidden').first().fadeIn()
