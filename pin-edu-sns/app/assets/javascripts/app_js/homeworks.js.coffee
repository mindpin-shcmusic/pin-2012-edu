pie.load ->
  jQuery('.students-selector, .courses-selector').chosen()
  jQuery('.add-student-attachement-field').click ->
    attachement_field = "<input type='text' size='30' name='homework[homework_student_upload_requirements_attributes][][title]'>"
    del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
    $('#student-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")

    # 删除表单
  jQuery('a.delete').live 'click', ->
    $(this).parent().remove()


  $upload_box = jQuery('.page-upload-box')

  jQuery('a.upload-teacher-homework-attachment-button').click ->
    pie.show_page_overlay()
    $upload_box.delay(200).fadeIn(200)

  jQuery('.page-upload-box a.form-cancel-button').click ->
    $upload_box.fadeOut 200, ->
      pie.hide_page_overlay()
