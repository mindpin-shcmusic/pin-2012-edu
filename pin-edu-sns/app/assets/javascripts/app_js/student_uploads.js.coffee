pie.load ->
  $uploader = $('.student-upload-requirements form')
  $button   = $uploader.find('.form-submit-button')
  $uploader.on 'submit', (e)->
    e.preventDefault()
    e.stopPropagation()

  $button.on 'click', ->
    $(this).closest('form').find('#attachment').trigger 'click'

  $uploader.find('input[type=file]').on 'change', ->
    file = $(this)[0].files[0]
    $container = $(this).closest('.upload-requirement')
    $container.find('.status').fadeIn()
    $bar = $container.find('.bar')
    $bar.css('width', 0)
    $container.find('.status').text('上传中...')

    data = new FormData $(this).closest('form')[0]
    data.append 'file_name', file.name

    set_progress = (e)->
      percent = "#{parseInt e.loaded / e.total * 100}%"
      $bar.css('width': percent)

    xhr_provider = ->
      xhr = $.ajaxSettings.xhr()
      xhr.upload.addEventListener 'progress',
                                  (e)-> set_progress(e),
                                  false
      xhr

    $request = $.ajax
      url  : $('.student-upload-requirements').data('upload-url')
      type : 'POST'
      data : data
      contentType: false
      processData: false
      xhr  : xhr_provider

    $request.success (res)=>
      console.log $container.find('.file-name').text(res)
      $container.find('.status').text('上传完毕')
