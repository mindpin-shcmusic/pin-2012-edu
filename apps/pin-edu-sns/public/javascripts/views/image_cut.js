jQuery(document).ready(function(){
  var original_img_elm = jQuery('.page-setting .original-img img');
   
  original_img_elm.Jcrop({
    onChange: showCoords,
    onSelect: showCoords,
    setSelect: [0, 0, 432, 432],
    aspectRatio: 1
  });
    
  function showCoords(coords){
    jQuery('form.copper-form')
      .find('input#x').val(coords.x).end()
      .find('input#y').val(coords.y).end()
      .find('input#w').val(coords.w).end()
      .find('input#h').val(coords.h).end();

    var rx = 96 / coords.w;
    var ry = 96 / coords.h;
    
    var imgx = original_img_elm.width();
    var imgy = original_img_elm.height();
    
    jQuery('.page-setting .crop-preview img').css({
        width      : ~~(rx * imgx),
        height     : ~~(ry * imgy),
        marginLeft : - ~~(rx * coords.x),
        marginTop  : - ~~(ry * coords.y)
    });
  }
});
