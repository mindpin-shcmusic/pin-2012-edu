pie.load ->
  jQuery('.page-new-course-score-list').find('.semester-selector, .course-selector').chosen()

  append_to_options = ($selector, res)->
    $selector.empty()
    $selector.append(new Option(obj.name, obj.id)) for obj in res
    $selector.trigger('liszt:updated')

  jQuery('.semester-selector').change ->
    semester         = jQuery(this).val()
    $course_selector = jQuery('.course-selector')
    url              = jQuery(this).data('url')

    jQuery.ajax
      url     : url
      type    : 'GET'
      data    : {'semester' : semester}
      success : (res)->
        append_to_options($course_selector, res)
