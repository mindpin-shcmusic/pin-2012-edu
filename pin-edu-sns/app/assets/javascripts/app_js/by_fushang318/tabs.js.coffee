pie.load ->
  jQuery(document).on 'click', '.tabs .navs .nav', ->
    $this_ele = jQuery(this)
    $tabs = $this_ele.closest('.tabs')
    index = $this_ele.index()
    
    $navs = $tabs.find('.navs')
    $contents = $tabs.find('.contents')
    nav_arr = $navs.find('> .nav')
    content_arr = $contents.find('> .content')

    nav_arr.removeClass('current')
    content_arr.removeClass('current')

    nav_arr.eq(index).addClass('current') 
    content_arr.eq(index).addClass('current')