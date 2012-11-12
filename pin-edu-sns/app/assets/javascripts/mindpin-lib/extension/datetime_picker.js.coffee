pie.load ->

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
    dateFormat: 'yy-mm-dd'
    firstDay: 7
    isRTL: false
    showMonthAfterYear: false
    yearSuffix: ''

  # 统一处理日期时间选择器
  jQuery('form input.datetime-picker').datetimepicker()

  jQuery('form input.date-picker').datepicker()
