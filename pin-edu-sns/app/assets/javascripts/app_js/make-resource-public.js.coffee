pie.load ->
  jQuery('.page-media-resource .public-resource a').on 'click', (e)->
    e.preventDefault()
    e.stopPropagation()
    jQuery.ajax
      type: 'POST'
      url : $(this).data('url')
      success: =>
        $(this).parent().fadeOut().html('公共资源').fadeIn()


