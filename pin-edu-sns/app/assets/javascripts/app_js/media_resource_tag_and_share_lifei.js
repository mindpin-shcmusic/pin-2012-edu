pie.load(function(){
  // 修改标签按钮
	function show_form(context) {
		var $parent = jQuery(context).closest('.resource-tag-list')
		$parent.next('.resource-edit-tags-form').fadeIn();
		$parent.hide();
	}

  function hide_form(context) {
		var $parent = jQuery(context).closest('.resource-edit-tags-form')
		$parent.prev('.resource-tag-list').fadeIn();
		$parent.hide();
	}

  jQuery(document).delegate('.edit-tag-form-button','click',function(){
    var tag_names = jQuery('.resource-tag-list .values').data('value');
    jQuery('.resource-edit-tag-form .tag_names').attr('value',tag_names);

		show_form(this);
  });

  // 修改标签表单 取消按钮
  jQuery(document).delegate('.resource-edit-tags-form .cancel','click',function(){
		hide_form(this);
  });

  // 修改标签表单 提交按钮
  jQuery(document).delegate('.resource-edit-tags-form .submit','click',function(){

    var tag_names_ele = jQuery('.resource-edit-tags-form .tag_names');
    var tag_names = tag_names_ele.attr('value')
    var post_url = tag_names_ele.data('url')
		var self = this;

    if(tag_names != ''){

      jQuery.ajax({
        url : post_url,
        type : 'PUT',
        data : {tag_names : tag_names},
        success : function(result){
          var values_ele = jQuery(self).parent().prev('.resource-tag-list').find('.values');
          values_ele.data('value',result);

          var a_eles = jQuery.map(result, function (tag_name) { 
            return '<a href=/tags/' +  tag_name + '>' + tag_name + '</a>';
          });
          values_ele.html(a_eles.join(''))

				  hide_form(self);
        },
        error : function(){
					hide_form(self);
        }
      });

    }

  });

});
