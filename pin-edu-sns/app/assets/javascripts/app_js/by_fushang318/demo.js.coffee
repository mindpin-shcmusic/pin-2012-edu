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
    
  
  



  
  
    
