jQuery(document).ready(function(){
	var preview_elm = jQuery('img.img-preview');
		 
    preview_elm.Jcrop({
        onChange: showCoords,
        onSelect: showCoords,
        setSelect: [0, 0, 432, 432],
        aspectRatio: 1
    });
    
    function showCoords(coords){
        jQuery('form.copper-form')
				  .find('#x1').val(coords.x).end()
					.find('#y1').val(coords.y).end()
					.find('#width').val(coords.w).end()
					.find('#height').val(coords.h).end();

        var rx = 100 / coords.w;
        var ry = 100 / coords.h;
        
				var imgx = preview_elm.width();
				var imgy = preview_elm.height();
				
        jQuery('img.preview-wrap').css({
            width: ~~(rx * imgx),
            height: ~~(ry * imgy),
            marginLeft: - ~~(rx * coords.x),
            marginTop: - ~~(ry * coords.y)
        });
    }
});
