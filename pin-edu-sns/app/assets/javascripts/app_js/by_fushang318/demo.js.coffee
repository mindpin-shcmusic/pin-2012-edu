pie.load ->
  jQuery('.tabs').each ->
    $tabs = jQuery(this)
    $navs = $tabs.find('.navs')
    $contents = $tabs.find('.contents')

    nav_arr = $navs.find('.nav')
    content_arr = $contents.find('.content')

    nav_arr.click ->
      index = jQuery(this).index()
      nav_arr.removeClass('current')
      content_arr.removeClass('current')

      nav_arr.eq(index).addClass('current') 
      content_arr.eq(index).addClass('current') 
