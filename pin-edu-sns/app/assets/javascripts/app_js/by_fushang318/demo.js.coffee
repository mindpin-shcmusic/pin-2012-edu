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

pie.load ->
  jQuery('.page-zhangjie-edit .editcontent').each ->
    $edit_content = jQuery(this)

    $edit = $edit_content.find('.edit')
    $info1 = $edit_content.find('.info1')
    $info2 = $edit_content.find('.info2')
    $form = $edit_content.find('.form')
    $save = $form.find('.save')

    $edit.click ->
      $edit.hide()
      $info1.hide()
      $form.show()
    $save.click ->
      $edit.show()
      $info2.css({display:'inline'})
      $form.hide()

pie.load ->
  count = 0
  $nav = jQuery('.page-zhangjie-edit .desc-info .tabs .navs .nav')
  jQuery('.page-zhangjie-edit .desc-info .tabs .navs .add').click ->
    $nav.eq(count).show()
    count+=1


pie.load ->
  $dynatree = jQuery('.page-zhangjie-edit .dynatree')

  $dynatree.dynatree
    debugLevel: 0
    children: $dynatree.data('children')

pie.load ->
  jQuery('.page-float-box.select .submit').click ->
    pie.close_fbox('select')
    jQuery('.page-zhangjie-edit .tabs .content').eq(1).find('.kejian-list').show()
  



  
  
    
