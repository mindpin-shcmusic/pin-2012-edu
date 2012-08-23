# 用户选择器

pie.load ->
  class UserSelector
    constructor: ->
      @$selector = jQuery('.page-form-user-selector')

      @$select_list = @$selector.find('.selector .list')
      @$users = @$select_list.find('.user')

      @$result_list = @$selector.find('.result .list')

      @$ids_input = @$selector.find('input.ids')

      @build_pinyin_engine()
      @bind_search_input()
      @bind()

    bind: ->
      that = this
      @$users.click ->
        $user = jQuery(this)
        if $user.hasClass('selected')
          that.unselect($user)
        else
          that.select($user)

    select: ($user)->
      $user.addClass('selected')
      @$result_list.prepend $user.clone().hide().fadeIn(100)
      @refresh_count()

    unselect: ($user)->
      $user.removeClass('selected')
      $_user = @$result_list.find(".user[data-id=#{$user.data('id')}]")
      $_user.fadeOut 100, =>
        $_user.remove()
        @refresh_count()

    refresh_count: ->
      $result_users = @$result_list.find('.user')
      length = $result_users.length

      @$selector.find('.result .count .c').html(length)

      arr = []
      $result_users.each ->
        arr.push jQuery(this).data('id')

      @$ids_input.val(arr.join(','))

    build_pinyin_engine: ->
      @engine = pinyinEngine()
      that = this

      @$users.each ->
        $user = jQuery(this)
        name = $user.data('name')

        that.engine.setCache([name], $user)

    pinyin_search: (value)->
      if jQuery.string(value).blank()
        return @$users.show()

      @$users.hide()
      @engine.search value, ($user)=>
        $user.show()

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