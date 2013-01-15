pie.load ->
  $todo = jQuery('.page-dashboard .todo')

  $filters = $todo.find('.filters')

  $course_list = $todo.find('.list.course')
  $homework_list = $todo.find('.list.homework')
  $custom_list = $todo.find('.list.custom')

  $course_filter = $todo.find('.filter.course')
  $homework_filter = $todo.find('.filter.homework')
  $custom_filter = $todo.find('.filter.custom')

  fun_remove_cla = ->
    $course_list.removeClass('current')
    $homework_list.removeClass('current')
    $custom_list.removeClass('current')
    $course_filter.removeClass('current')
    $homework_filter.removeClass('current')
    $custom_filter.removeClass('current')

  $filters.find('.filter.course').click ->
    fun_remove_cla()

    $course_list.addClass('current')
    $course_filter.addClass('current')

  $filters.find('.filter.homework').click ->
    fun_remove_cla()

    $homework_list.addClass('current')
    $homework_filter.addClass('current')

  $filters.find('.filter.custom').click ->
    fun_remove_cla()

    $custom_list.addClass('current')
    $custom_filter.addClass('current')
    