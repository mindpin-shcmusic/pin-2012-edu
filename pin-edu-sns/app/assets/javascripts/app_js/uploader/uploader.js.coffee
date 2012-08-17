class FileUploader
  constructor: ($upload_button, options)->
    @$button = $upload_button

    @BLOB_SIZE = 524288 # 1024 * 512 bytes 512K / 每段
    @UPLOAD_URL = '/upload'

    # funcs
    @render         = options.render || ->
    @set_progress   = options.set_progress || ->
    @set_speed      = options.set_speed || ->
    @success        = options.success || ->
    @error          = options.error || ->

    @bind_button()

  bind_button: ->
    that = this

    @$button.find('input[type=file]').live 'change', (evt)->
      files = evt.target.files

      jQuery.each files, (index, file)=>
        # console.log file
        # TODO 这里需要加入文件是否重复上传的判断
        new FileUploadWrapper(that, file).render().upload()


class FileUploadWrapper
  constructor: (uploader, file)->
    @uploader = uploader
    @file = file

    @file_name = jQuery.string(@file.name).escapeHTML().str
    @file_size = @file.size
    @uploaded_size = 0

    @xhr = new XMLHttpRequest
    @xhr.onload = @xhr_onload

  render: ->
    @$elm = @uploader.render(this)
    @set_progress(0)
    @set_speed(0)
    return this

  set_progress: (percent)->
    @uploader.set_progress(@$elm, percent)

  set_speed: (speed)->
    @uploader.set_speed(@$elm, speed)

  success: ->
    @uploader.success(this)

  error: (msg)->
    @uploader.error(@$elm, msg)

  get_size_str: ->
    mbs = @file_size / 1024 / 1024
    return "#{Math.floor(mbs * 100) / 100}MB"

  upload: ->
    if 0 == @file_size
      @show_error '请不要上传空文件'
      return

    @last_refreshed_time = new Date

    @xhr.open 'POST', @uploader.UPLOAD_URL, true
    @xhr.send @get_form_data()

  xhr_onload: (evt)=>
      # console.log '上传blob'
      status = @xhr.status

      if status >= 200 && status < 300 || status == 304
        res = jQuery.string(@xhr.responseText).evalJSON()
        @uploaded_size = res.saved_size

        @set_progress_on_upload()

        # console.log "文件大小: #{@file_size}"
        # console.log "已上传: #{@uploaded_size}"

        @FILE_ENTITY_ID = @FILE_ENTITY_ID || res.file_entity_id

        @continue()
      else
        # console.log "blob上传出错: #{status}"
        @error()

  set_progress_on_upload: ->
    # 上传百分比
    percent = (@uploaded_size * 100 / @file_size).toFixed(1)

    # 上传速度
    new_time = new Date
    time_delta = new_time - @last_refreshed_time
    size_delta = @uploader.BLOB_SIZE
    speed = (size_delta / time_delta).toFixed(1)

    @set_progress percent
    @set_speed speed

  get_form_data: ->
    form_data = new FormData
    form_data.append 'name', @file_name
    form_data.append 'size', @file_size
    if @FILE_ENTITY_ID
      form_data.append 'file_entity_id', @FILE_ENTITY_ID
    
    form_data.append 'blob', @get_next_blob()
    return form_data

  continue: ->
    if @is_finished()
      console.log '上传完毕'
      # @set_progress(100)

      @success()

      return

    @upload()

  is_finished: ->
    return @uploaded_size >= @file.size

  get_next_blob: ->
    File.prototype.mindpin_slice = 
      File.prototype.slice ||
      File.prototype.webkitSlice ||
      File.prototype.mozSlice

    start_byte = @uploaded_size
    end_byte   = start_byte + @uploader.BLOB_SIZE

    # console.log "blob分段: #{start_byte} - #{end_byte}"

    return @file.mindpin_slice(start_byte, end_byte)


# 媒体资源
pie.load ->
  
  $upload_button = jQuery('.page-media-resource-head .page-upload-button')
  $uploader_elm = jQuery('.page-media-file-uploader')

  if $upload_button.exists() && $uploader_elm.exists()

    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->
        # 显示上传框
        $upload_box = jQuery('.page-upload-box')
        $upload_box.delay(200).fadeIn(200)

        # 添加上传进度条
        $file_elm = $uploader_elm.find('.progress-bar-sample .file').clone()
        $list = $uploader_elm.find('.uploading-files-list').append $file_elm

        $file_elm.find('.name').html file_wrapper.file_name
        $file_elm.find('.size').html file_wrapper.get_size_str()

        $file_elm
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file_elm

      set_progress: ($wrapper, percent)->
        pstr = "#{percent}%"

        $wrapper.find('.percent').html(pstr)

        if 0 == percent
          $wrapper.find('.bar .p').css('width', pstr)
        else
          $wrapper.find('.bar .p').animate({'width': pstr}, 100)

      set_speed: ($wrapper, speed)->
        $wrapper.find('.speed').html("#{speed}KB/s")

      success: (file_wrapper)->
        # 创建媒体资源记录
        FILE_PUT_URL = '/file_put'
        CURRENT_PATH = $uploader_elm.data('current-path')

        file_name = file_wrapper.file_name

        url = jQuery.path_join(FILE_PUT_URL, CURRENT_PATH, file_name)

        jQuery.ajax
          url:  url
          type: 'PUT'
          data:
            'file_entity_id' : file_wrapper.FILE_ENTITY_ID

          success: (res)-> # 返回应该是一个字符串，新的 media_file_id
            $list = jQuery('.page-media-resources')
            $list.prepend jQuery(res).find('.media-resource')
            jQuery(document).trigger('ajax:create-resource')

          error: ->
            file_wrapper.show_error

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.error').append msg || ''

# 作业附件上传
pie.load ->

  $upload_button = jQuery('.page-homework-form .page-upload-button')

  if $upload_button.exists()
    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->        
        # 添加上传进度条
        $file_elm = jQuery('.page-homework-form .field.attachments .sample.hide .file').clone()
        $list = jQuery('.page-homework-form .field.attachments')

        $file_elm.find('.name').html file_wrapper.file_name
        # $file_elm.find('.size').html file_wrapper.get_size_str()

        $file_elm
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file_elm

      set_progress: ($wrapper, percent)->
        pstr = "#{percent}%"

        $wrapper.find('.percent').html(pstr)

        if 0 == percent
          $wrapper.find('.bar .p').css('width', pstr)
        else
          $wrapper.find('.bar .p').animate({'width': pstr}, 100)

      success: (file_wrapper)->
        # 创建媒体资源记录
        file_entity_id = file_wrapper.FILE_ENTITY_ID

        file_wrapper.$elm.find('input').val(file_entity_id)