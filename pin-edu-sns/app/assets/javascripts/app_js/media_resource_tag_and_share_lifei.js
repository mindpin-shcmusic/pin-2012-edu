pie.load(function(){
  // 修改标签按钮
  jQuery(document).delegate(".page-media-resource .edit-tag-form-button","click",function(){
    var tag_names = jQuery(".page-media-resource .tag-list .values").data("value");
    jQuery(".page-media-resource .edit-tag-form .tag_names").attr("value",tag_names);

    jQuery(".page-media-resource .edit-tag-form").show();
    jQuery('.page-media-resource .tag-list').hide();
  });

  // 修改标签表单 取消按钮
  jQuery(document).delegate(".page-media-resource .edit-tag-form .cancel","click",function(){
    jQuery(".page-media-resource .edit-tag-form").hide();
    jQuery('.page-media-resource .tag-list').show();
  });

  // 修改标签表单 提交按钮
  jQuery(document).delegate(".page-media-resource .edit-tag-form .submit","click",function(){

    var tag_names_ele = jQuery(".page-media-resource .edit-tag-form .tag_names");
    var tag_names = tag_names_ele.attr("value")
    var post_url = tag_names_ele.data("url")

    if(tag_names != ""){

      jQuery.ajax({
        url : post_url,
        type : 'POST',
        data : {tag_names : tag_names},
        success : function(result){
          var values_ele = jQuery(".page-media-resource .tag-list .values");
          values_ele.data("value",result);

          var a_eles = jQuery.map(result, function (tag_name) { 
            return "<a href='/tags/" + tag_name +"'>"+ tag_name + "</a>";
          });
          values_ele.html(a_eles.join(""))

          jQuery(".page-media-resource .edit-tag-form").hide();
          jQuery('.page-media-resource .tag-list').show();
        },
        error : function(){
          jQuery(".page-media-resource .edit-tag-form").hide();
          jQuery('.page-media-resource .tag-list').show();
        }
      });

    }

  });

});
