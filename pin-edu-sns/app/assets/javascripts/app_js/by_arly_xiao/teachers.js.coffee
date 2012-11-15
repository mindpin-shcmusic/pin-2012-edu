pie.load ->
  # 老师 show 页面
  jQuery(document).delegate '.teacher-course .detail', 'click', ->
    id = $(this).data('id')
    $('#course-' + id).toggle()

  
  # 课程，任课老师页面
  jQuery(document).delegate '.teacher-student .detail', 'click', ->
    id = $(this).data('id')
    $('#teacher-' + id).toggle()