pie.load ->
  $upload_box = jQuery('.page-upload-box')

  jQuery('.students-selector, .courses-selector').chosen()
  jQuery('.add-student-attachement-field').click ->
    attachement_field = "<input type='text' size='30' name='homework[homework_requirements_attributes][][title]'>"
    del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
    $('#student-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")

    # 删除表单
  jQuery('a.delete').live 'click', ->
    $(this).parent().remove()


  jQuery('a.upload-teacher-homework-attachment-button').click ->
    pie.show_page_overlay()
    $upload_box.delay(200).fadeIn(200)

  jQuery('.page-upload-box a.form-cancel-button').click ->
    $upload_box.fadeOut 200, ->
      pie.hide_page_overlay()

  jQuery('.uploaded-teacher-attachments .attachment a').click ->
    console.log $(this).data('destroy-url')
    $(this).confirm_dialog '确定删除么？', =>
      $request = $.ajax
        url  : $(this).data('destroy-url')
        type : 'DELETE'

      $request.success =>
        $(this).parent().hide()

  jQuery('.added-requirements .requirement a').click ->
    console.log $(this).data('destroy-url')
    $(this).confirm_dialog '确定删除么？', =>
      $request = $.ajax
        url  : $(this).data('destroy-url')
        type : 'DELETE'

      $request.success =>
        $(this).parent().hide()

  jQuery('.set-finished a').click ->
    $request = $.ajax
      url  : $(this).data('url')
      type : 'PUT'

    $request.success =>
      $(this).parent().fadeOut()
      $('.student-home-work-status .signed').removeClass('hide').hide().fadeIn()


  jQuery('.set-submitted a').click ->
    console.log($(this).data('url'))
    $request = $.ajax
      url  : $(this).data('url')
      type : 'PUT'
      data :
        'content': $(this).parent().find('input').val()

    $request.success =>
      $(this).parent().fadeOut()
