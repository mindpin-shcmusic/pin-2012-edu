# 班级学生分配 -> 学生选择器

pie.load ->
  class UserSelector
    constructor: ->
      @$selector = jQuery('.page-admin-students-selector')

      @$select_list = @$selector.find('.selector .list')
      @$stundets = @$select_list.find('.student')

      @$result_list = @$selector.find('.result .list')

      @$ids_input = @$selector.find('input.ids')

      @build_pinyin_engine()
      @bind_search_input()
      @bind()

    bind: ->
      that = this
      @$stundets.click ->
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
      $result_students = @$result_list.find('.student')
      length = $result_students.length

      @$selector.find('.result .count .c').html(length)

      arr = []
      $result_students.each ->
        arr.push jQuery(this).data('id')

      @$ids_input.val(arr.join(','))

    build_pinyin_engine: ->
      @engine = pinyinEngine()
      that = this

      @$stundets.each ->
        $student = jQuery(this)
        name = $student.data('name')

        that.engine.setCache([name], $student)

    pinyin_search: (value)->
      if jQuery.string(value).blank()
        return @$stundets.show()

      @$stundets.hide()
      @engine.search value, ($student)=>
        $student.show()

    bind_search_input: ->
      $search_input = @$selector.find('input.search')
      $search_input.val('')
      @search_timer = null

      $search_input.input =>
        value = $search_input.val()
        return if value == @old_value
        @old_value = value

        clearTimeout @search_timer
        console.log(value)
        func = => 
          @pinyin_search(value)

        @search_timer = setTimeout func, 40
        

  new UserSelector()