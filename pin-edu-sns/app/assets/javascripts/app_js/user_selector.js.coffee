# 班级学生分配 -> 学生选择器

pie.load ->
  class UserSelector
    constructor: ->
      @$selector = jQuery('.page-admin-students-selector')
      @$result_list = @$selector.find('.result .list')
      @$input = @$selector.find('input.ids')

      @bind()

    bind: ->
      that = this
      @$selector.find('.selector .list .student').click ->
        $student = jQuery(this)
        if $student.hasClass('selected')
          that.unselect($student)
        else
          that.select($student)

    select: ($student)->
      $student.addClass('selected')
      @$result_list.prepend $student.clone().hide().fadeIn(100)
      @refresh_count()

    unselect: ($student)->
      $student.removeClass('selected')

      $_student = @$result_list.find(".student[data-id=#{$student.data('id')}]")
      $_student.fadeOut 100, =>
        $_student.remove()
        @refresh_count()

    refresh_count: ->
      $students = @$result_list.find('.student')
      @$selector.find('.result .count .c').html($students.length)

      arr = []
      $students.each ->
        arr.push jQuery(this).data('id')

      @$input.val(arr.join(','))

  new UserSelector()