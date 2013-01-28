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

  count = 0
  $nav = jQuery('.page-zhangjie-edit .desc-info .tabs .navs .nav')
  jQuery('.page-zhangjie-edit .desc-info .tabs .navs .add').click ->
    if 0 == count
      $tabs = jQuery('.page-zhangjie-edit .tabs')
      $navs = $tabs.find('.navs')
      $contents = $tabs.find('.contents')
      $nav_arr = $navs.find('.nav')
      $content_arr = $contents.find('.content')
      $nav_arr.eq(0).addClass('current') 
      $content_arr.eq(0).addClass('current') 

    $nav.eq(count).show()
    count+=1

pie.load ->
  $dynatree = jQuery('.page-zhangjie-edit .dynatree')

  $dynatree.dynatree
    debugLevel: 0
    children: $dynatree.data('children')

pie.load ->
  jQuery('.page-float-box.select-2 .submit').click ->
    pie.close_fbox('select-2')
    jQuery('.page-zhangjie-edit .tabs .content').eq(1).find('.kejian-list').show()


pie.load ->
  jQuery('.page-fangan-review .zhangjie1').click ->
    jQuery('.page-fangan-review .preview2').hide()
    jQuery('.page-fangan-review .preview1').show()
  jQuery('.page-fangan-review .zhangjie2').click ->
    jQuery('.page-fangan-review .preview1').hide()
    jQuery('.page-fangan-review .preview2').show()
    
  
  



  
  
    
