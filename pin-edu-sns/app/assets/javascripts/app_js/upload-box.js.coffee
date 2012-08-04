pie.load ->
  $upload_link = jQuery('.page-media-resources-forms .upload-link')
  $upload_box = jQuery('.upload-box')
  $uploader = jQuery('.page-media-file-uploader')

  $upload_link.click ->
    #pie.show_page_overlay()
    $uploader.data('current-path', $upload_link.data('path'))
    $upload_box.slideDown()

    jQuery('body').click (e)->
      #pie.hide_page_overlay()
      console.log 
      if !$(e.target).closest('.upload-box').length && $(e.target).attr('class') != 'upload-link'
        $uploader.data('path', null)
        $upload_box.slideUp()

