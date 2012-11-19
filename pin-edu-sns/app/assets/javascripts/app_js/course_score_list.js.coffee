pie.load ->
  jQuery('.page-new-course-score-list .field').find('select').select2()
  $course_selector = jQuery('select.course-selector')

  append_to_options = ($selector, res)->
    $selector.empty()
    $selector.append(new Option(obj.name, obj.id)) for obj in res
    $selector.trigger('liszt:updated')

  jQuery('.semester-selector').change ->
    semester = jQuery(this).val()
    url      = jQuery(this).data('url')

    jQuery.ajax
      url     : url
      type    : 'GET'
      data    : {'semester' : semester}
      success : (res)->
        append_to_options($course_selector, res)
