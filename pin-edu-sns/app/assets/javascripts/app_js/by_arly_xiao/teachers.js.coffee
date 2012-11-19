pie.load ->
  # 老师 show 页面
  jQuery(document).delegate '.student-detail', 'click', ->
    id = $(this).data('id')
    $('#course-' + id).toggle()
    $('.a-notice-' + id).toggle()
    $('.b-notice-' + id).toggle()

  
  # 课程，任课老师页面
  jQuery(document).delegate '.student-detail', 'click', ->
    id = $(this).data('id')
    $("#teacher-#{id}").toggle()

    if $("#teacher-#{id}:visible")
      $('#a-notice-' + id).hide()
      $('#b-notice-' + id).show()

    if $("#teacher-#{id}:hidden")
      $('#a-notice-' + id).show()
      $('#b-notice-' + id).hide()
