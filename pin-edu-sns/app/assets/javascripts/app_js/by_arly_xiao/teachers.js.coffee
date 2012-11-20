# 此js用来控制任课教师show页面的课程学生信息展开和折叠

pie.load ->
  jQuery(document).delegate '.page-admin-teacher .course a.open', 'click', ->
    jQuery(this).closest('.course').addClass('opened')

  jQuery(document).delegate '.page-admin-teacher .course a.close', 'click', ->
    jQuery(this).closest('.course').removeClass('opened')