pie.load ->
  $upload_box = jQuery('.page-upload-box')

  jQuery('.students-selector, .courses-selector').chosen()

  jQuery.timepicker.regional['cn'] =
  	timeText: '时间',
  	hourText: '小时',
  	minuteText: '分钟',
  	secondText: '秒',
  	millisecText: '毫秒',
  	currentText: '现在时间',
  	closeText: '关闭',
  	ampm: false

  jQuery.timepicker.setDefaults(jQuery.timepicker.regional['cn'])

  jQuery.datepicker.regional['cn'] =
  	closeText: '关闭'
  	prevText: '<上一个月'
  	nextText: '下一个月>'
  	monthNames: ['一月','二月','三月','四月','五月','六月'
  	'七月','八月','九月','十月','十一月','十二月']
  	monthNamesShort: ['1','2','3','4','5','6'
  	'7','8','9','10','11','12']
  	dayNames: ['星期一','星期二','星期三','星期四','星期五','星期六','星期天']
  	dayNamesShort: ['一','二','三','四','五','六','七']
  	dayNamesMin: ['一','二','三','四','五','六','七']
  	dateFormat: 'yy.mm.dd'
  	firstDay: 7
  	isRTL: false
  	showMonthAfterYear: false
    
  	yearSuffix: ''

  jQuery.datepicker.setDefaults(jQuery.datepicker.regional['cn'])

  jQuery('.homework-deadline').datetimepicker()

  jQuery('.add-student-attachement-field').click ->
    attachement_field = "<input type='text' size='30' name='homework[homework_requirements_attributes][][title]'>"
    del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
    $('#student-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")

  #   # 删除表单
  # jQuery('a.delete').live 'click', ->
  #   $(this).parent().remove()


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
