pie.load ->
  jQuery('.semester-selector').chosen()
  jQuery('.course-selector').chosen()
  jQuery('.teacher-selector').chosen()

  # 根据学期动态显示课程
  jQuery(document).delegate '#semester', 'change', ->
    jQuery.ajax
      url: '/admin/course_surveys/show_courses_by_semester'
      type: 'GET'
      data: {
        'semester' : jQuery(this).val()
      }
      success: (res)->
        i = 0
        while i < res.length
          jQuery('#course').append(new Option(res[i].name, res[i].id))
          i++


  # 根据课程动态显示老师
  jQuery(document).delegate '#course', 'change', ->
    jQuery.ajax
      url: '/admin/course_surveys/show_teachers_by_course'
      type: 'GET'
      data: {
        'course_id' : jQuery(this).val()
        'semester' : jQuery('#semester').val()
      }
      success: (res)->
        i = 0
        while i < res.length
          jQuery('#teacher').append(new Option(res[i].real_name, res[i].id))
          i++       
    