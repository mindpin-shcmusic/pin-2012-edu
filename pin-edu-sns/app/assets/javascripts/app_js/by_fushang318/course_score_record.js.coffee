pie.load ->
  $form = jQuery('.page-model-form.new-course-score-record')
  return if !$form.exists()

  $student_select = $form.find('select.student-select')
  $form.find('select.course-select').on 'change', ->
    jQuery.ajax
      url: '/admin/course_score_records/get_students_by_course'
      type: 'GET'
      data:
        course_id : jQuery(this).val()
      success: (res)->
        $student_select.empty()

        i = 0
        $student_select.append(new Option("", ""))
        while i < res.length
          $student_select.append(new Option(res[i].name, res[i].id))
          i++
        $student_select.select2("val", {id:"", text:""})
          