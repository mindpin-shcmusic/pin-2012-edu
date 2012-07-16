pie.load(function(){

  // 隐藏表单，显示描述内容
  function hidden_form_and_show_content(){
    jQuery(".page-media-file-show-wrapper .bd .info .description-content").css("display","block");
    jQuery(".page-media-file-show-wrapper .bd .info .description-form").css("display","none");
  }

  jQuery(".page-media-file-show-wrapper .bd .info a.edit").live('click', function(){
    // 显示表单，隐藏描述内容
    jQuery(".page-media-file-show-wrapper .bd .info .description-content").css("display","none");
    jQuery(".page-media-file-show-wrapper .bd .info .description-form").css("display","block");
  });

  jQuery(".page-media-file-show-wrapper .bd .info .description-form a.cancel").live('click', function(){
    // 表单中的内容还原
    var value = jQuery(".page-media-file-show-wrapper .bd .info .description-content").text();
    var description_text_area = jQuery(".page-media-file-show-wrapper .bd .info .description-form #description");
    var value = description_text_area.attr("value",value);
    hidden_form_and_show_content();
  });

  jQuery(".page-media-file-show-wrapper .bd .info .description-form a.submit").live('click', function(){
    var url = jQuery(this).domdata('url');
    console.log(url);
    var description_text_area = jQuery(".page-media-file-show-wrapper .bd .info .description-form #description");
    var value = description_text_area.attr("value");
    console.log(value);
    if(jQuery.string(value).blank()){
      // 当内容为空的时候，页面有个错误提示
    }else{
      jQuery.ajax({
        type : 'POST',
        url : url,
        data : { description : value},
        success : function(data){
          jQuery(".page-media-file-show-wrapper .bd .info .description-content").text(value);
          description_text_area.attr("value",value);
          hidden_form_and_show_content();
        }
      })
    }
  });

});






