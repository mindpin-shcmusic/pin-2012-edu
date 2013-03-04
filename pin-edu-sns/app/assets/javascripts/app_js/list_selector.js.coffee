# 用户选择器

pie.load ->
  class ListSelector
    constructor: (list_selector)->
      @$list_selector = jQuery(list_selector)
      @$mode = 'all'

      @$filter = @$list_selector.find('.filter')
      @$selector = @$list_selector.find('.selector')
      @$ids_input = @$list_selector.find('input.ids')
      @$search_input = @$list_selector.find('input.search')

      @$search_input.val('')
      @$search_timer = null

      @$list = @$selector.find('.list')
      @$items = @$list.find('.item')
      @build_items_hash()
      @build_filter()
      @build_pinyin_engine()
      @bind_search_input()
      @bind()

    build_items_hash: ->
      @$items_hash = {}
      that = this
      @$items.each ->
        $item = jQuery(this)
        that.$items_hash[$item.data('id')] = $item

    build_filter: ->
      that = this
      @$filter.find('a.all').on 'click', ->
        that.$filter.find('a').removeClass('view')
        jQuery(this).addClass('view')
        that.$mode = 'all'
        that.$items.show()
      @$filter.find('a.selected').on 'click', ->
        that.$filter.find('a').removeClass('view')
        jQuery(this).addClass('view')
        that.$mode = 'selected'
        that.$items.hide()
        that.$list.find('.item.selected').show()
      @$filter.find('a.unselected').on 'click', ->
        that.$filter.find('a').removeClass('view')
        jQuery(this).addClass('view')
        that.$mode = 'unselected'
        that.$items.hide()
        that.$list.find('.item:not(.selected)').show()

    bind: ->
      that = this
      @$items.on 'click', ->
        $item = jQuery(this)
        if $item.hasClass('selected')
          that.unselect($item)
        else
          that.select($item)

    select: ($item)->
      $item.addClass('selected')
      if @$mode == 'selected'
        $item.show()
      else if @$mode == 'unselected'
        $item.hide()
      @refresh_count()

    unselect: ($item)->
      $item.removeClass('selected')
      if @$mode == 'selected'
        $item.hide()
      else if @$mode == 'unselected'
        $item.show()
      @refresh_count()

    refresh_count: ->
      $result_items = @$list.find('.item.selected')

      arr = []
      $result_items.each ->
        arr.push jQuery(this).data('id')

      @$ids_input.val(arr.join(','))

    build_pinyin_engine: ->
      @engine = pinyinEngine()
      that = this

      @$items.each ->
        $item = jQuery(this)
        name = $item.data('name')

        that.engine.setCache([name], $item)

    pinyin_search: (value)->
      if jQuery.string(value).blank()
        return @$items.show()

      @$items.hide()
      that = this
      @engine.search value, ($item)=>
        if that.$mode == 'selected'
          if $item.hasClass('selected')
            $item.show()
        else if that.$mode == 'unselected'
          if !$item.hasClass('selected')
            $item.show()
        else if that.$mode == 'all'
          $item.show()

    bind_search_input: ->
      that = this
      @$search_input.input =>
        value = that.$search_input.val()
        return if value == that.old_value
        that.old_value = value

        clearTimeout that.search_timer
        console.log(value)
        func = => 
          that.pinyin_search(value)

        that.search_timer = setTimeout func, 40

    get_selected_ids: ->
      ids = []
      @$list.find('.item.selected').each ->
        $item = jQuery(this)
        id = $item.data('id')
        ids.push(id)
      return ids

    set_selected_ids: (ids)->
      that = this
      $old_selected_items = @$list.find('.item.selected')
      $new_selected_items = jQuery.map ids, (id)->
        that.$items_hash[id]

      # 取消选择
      $old_selected_items.each ->
        $item = jQuery(this)
        $item.removeClass('selected')
        if that.$mode == 'selected'
          $item.hide()
        else if that.$mode == 'unselected'
          $item.show()
      # 选择
      jQuery.each $new_selected_items, (index,$item)->
        $item.addClass('selected')
        if that.$mode == 'selected'
          $item.show()
        else if that.$mode == 'unselected'
          $item.hide()
      @refresh_count()


  jQuery('.list-selector').each ->
    ele = jQuery(this)
    ele.data('list_selector',new ListSelector(ele))
    