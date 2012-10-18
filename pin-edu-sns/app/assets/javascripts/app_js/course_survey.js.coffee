pie.load ->
  # 根据学期动态显示课程
  jQuery(document).delegate '#course_survey_semester_value', 'change', ->
    jQuery.ajax
      url: '/admin/course_surveys/show_courses_by_semester'
      type: 'GET'
      data: {
        'semester' : jQuery(this).val()
      }
      success: (res)->
        $('#course_survey_course_id').empty()

        i = 0
        while i < res.length
          jQuery('#course_survey_course_id').append(new Option(res[i].name, res[i].id))
          jQuery('#course_survey_course_id').trigger('liszt:updated')
          i++


  # 根据课程动态显示老师
  jQuery(document).delegate '#course_survey_course_id', 'change', ->
    jQuery.ajax
      url: '/admin/course_surveys/show_teachers_by_course'
      type: 'GET'
      data: {
        'course_id' : jQuery(this).val()
        'semester' : jQuery('#course_survey_semester_value').val()
      }
      success: (res)->
        $('#course_survey_teacher_user_id').empty()
        i = 0
        while i < res.length
          jQuery('#course_survey_teacher_user_id').append(new Option(res[i].name, res[i].id))
          jQuery('#course_survey_teacher_user_id').trigger('liszt:updated')
          i++       
    