# jQuery ->
# 	$upload_form = jQuery('.page-media-resources-forms form.upload-file')

# 	if $upload_form.length > 0
# 		$upload_form.find('input[type=file]').change ->
# 			value = jQuery(this).val().replace(/// \\ ///g, '/')
# 			arr = value.split('/')
# 			filename = arr[arr.length - 1]

# 			current_path = $upload_form.find('input[name=current_path]').val()
# 			resource_path = 
# 				if current_path == '/' 
# 				then "/#{filename}" 
# 				else "#{current_path}/#{filename}"

# 			action = "/file_put#{resource_path}"

# 			$upload_form.attr('action', action)
# 			console.log(action)


# jQuery ->
#   jQuery('.page-media-resource-list .media-resource a.put-public').live 'click', ->
#     elm = jQuery(this)
#     id = elm.data('id')

#     jQuery.ajax({
#       type: 'POST',
#       url : '/public_resources/share/',
#       data: {resource_id: id},
#       success : ->
#         elm.remove()
#     })

# pie.load ->
#   $upload_link = jQuery('.page-media-resources-forms .upload-link')
#   $upload_box = jQuery('.upload-box')
#   $uploader = jQuery('.page-media-file-uploader')

#   $upload_link.click ->
#     #pie.show_page_overlay()
#     $uploader.data('current-path', $upload_link.data('path'))
#     $upload_box.slideDown()

#     jQuery('body').click (e)->
#       #pie.hide_page_overlay()
#       console.log 
#       if !$(e.target).closest('.upload-box').length && $(e.target).attr('class') != 'upload-link'
#         $uploader.data('path', null)
#         $upload_box.slideUp()

# 我的文件夹 -> 创建文件夹
pie.load ->
  jQuery(document).delegate '.page-media-resource-head a.create-folder-button', 'click', ->
    $box = jQuery(this).closest('.page-media-resource-head').find('.create-folder-box')
    default_name = $box.data('default-name')
    pie.show_page_overlay()
    $box
      .delay(200).fadeIn(200)
      .find('form input[name=folder]').val(default_name)

  jQuery(document).delegate '.page-media-resource-head .create-folder-box .form-cancel-button', 'click', ->
    $box = jQuery(this).closest('.create-folder-box')
    $box.fadeOut 200, ->
      pie.hide_page_overlay()

  jQuery(document).delegate '.page-media-resource-head .create-folder-box .form-submit-button', 'click', ->
    $box = jQuery(this).closest('.create-folder-box')
    $form = $box.find('form')
    if pie.is_form_all_need_filled($form)
      url = $form.attr('action')
      data = $form.serialize()
      jQuery.ajax
        url: url
        type: 'POST'
        data: data
        success: (res)->
          $list = jQuery('.page-media-resources')
          $list.prepend jQuery(res).find('.media-resource')
          jQuery(document).trigger('ajax:create-folder')

          $box.fadeOut 200, ->
            pie.hide_page_overlay()
