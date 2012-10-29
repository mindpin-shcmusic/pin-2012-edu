pie.load ->
  # 布置作业时，选择班级
  jQuery('.page-homework-form .teams-selector').chosen()

  # 布置作业时，选择课程
  jQuery('.page-homework-form .courses-selector').chosen()

  # ------------------

  # 时间选择器中文化
  jQuery.timepicker.setDefaults
    timeText: '时间',
    hourText: '小时',
    minuteText: '分钟',
    secondText: '秒',
    millisecText: '毫秒',
    currentText: '现在时间',
    closeText: '关闭',
    ampm: false

  # 日期选择器中文化
  jQuery.datepicker.setDefaults
    closeText: '关闭'
    prevText: '<上一个月'
    nextText: '下一个月>'
    monthNames: ['一月','二月','三月','四月','五月','六月'
    '七月','八月','九月','十月','十一月','十二月']
    monthNamesShort: ['1','2','3','4','5','6'
    '7','8','9','10','11','12']
    dayNames: ['星期一','星期二','星期三','星期四','星期五','星期六','星期天']
    dayNamesShort: ['七', '一','二','三','四','五','六']
    dayNamesMin: ['七', '一','二','三','四','五','六']
    dateFormat: 'yy.mm.dd'
    firstDay: 7
    isRTL: false
    showMonthAfterYear: false
    yearSuffix: ''

  jQuery('.page-homework-form .homework-deadline').datetimepicker()

  # -------------------

  # 创建作业，增加需求项
  jQuery('.page-homework-form .add-student-attachement-field').click ->
    attachement_field = "<input type='text' size='30' name='homework[homework_requirements_attributes][][title]'>"
    del_field = "<a href='javascript:;' class='delete'>×</a>"
    jQuery('.page-homework-form .student-attachement-fields').append("<div>#{attachement_field}#{del_field}</div>")

  # 删除需求项
  jQuery('.page-homework-form .student-attachement-fields a.delete').live 'click', ->
    jQuery(this).parent().remove()

  # --------------------

  # 老师确定作业完成
  jQuery('.page-homework-student .set-finished a').click ->
    $request = $.ajax
      url  : $(this).data('url')
      type : 'PUT'

    $request.success =>
      $(this).parent().fadeOut()
      $('.student-home-work-status .signed').removeClass('hide').hide().fadeIn()


  jQuery('.page-homework-show .student-submit a.form-button').click ->
    $student_submit = jQuery(this).closest('.student-submit')
    url = $student_submit.data('url')
    content = $student_submit.find('textarea').val()

    jQuery.ajax
      url: url
      type: 'PUT'
      data:
        content: content
      success: =>
        $student_submit.text('作业已提交！')



  jQuery('.page-homework-student .upload a.comments-count').live 'click', ->
    $upload = jQuery(this).closest('.upload')
    model_id = $upload.data('id')
    model_type = 'HomeworkStudentUpload'

    if $upload.find('.page-comments').exists()
      $upload.find('.page-comments').fadeOut 200, ->
        $upload.find('.page-comments').remove()
    else
      jQuery.ajax
        url: '/comments/show_model_comments'
        type: 'GET'
        data: {
          'model_id' : model_id
          'model_type' : model_type
        }
        success: (res)->
          $comments = jQuery(res)
          $comments.appendTo($upload).hide().fadeIn(200)