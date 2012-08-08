$ ->
  UPLOADER_ELM   = $ '.home-attachment-uploader .page-attachment-uploader'
  return if 0 == UPLOADER_ELM.length

  class HomeworkAttachment
    constructor: (@file)->
      @BLOB_SIZE      = 524288
      @FILE_PUT_URL   = UPLOADER_ELM.data 'file-put-url'
      @SEND_BLOB_URL  = UPLOADER_ELM.data 'send-blob-url'
      @NEW_UPLOAD_URL = UPLOADER_ELM.data 'new-upload-url'
      @uploaded_byte = 0
      @read_byte     = 0
      @elm = UPLOADER_ELM.find('.progress-bar-sample .file').clone()

    show_error: (msg)->
      @elm.addClass('error').find('.error-info').append(msg || '')

    start_upload: ->
      if @file.size == 0
        @show_error('请不要上传空文件')
        return

      @last_refreshed_time = new Date

      $request = $.ajax
        url  : @NEW_UPLOAD_URL
        type : 'POST'
        data :
          'file_name' : @file.name
          'file_size' : @file.size

      $request.success (res)=>
        console.log 'new upload'
        console.log res
        @uploaded_bytes = res.saved_size
        @SLICE_TEMP_FILE_ID = res.slice_temp_file_id
        @inform_or_upload()

      $request.error =>
        @show_error()

    _get_form_data: ->
      form_data = new FormData
      form_data.append 'slice_temp_file_id', @SLICE_TEMP_FILE_ID
      form_data.append 'file_blob', @get_blob()
      form_data

    inform_or_upload: ->
      if @is_uploading_finished()
        console.log '上传完毕'
        @file_put()
        @set_progress(100)
        return

      @upload_blob()

    upload_blob: ->
      xhr = new XMLHttpRequest

      xhr.open('POST', @SEND_BLOB_URL, true)

      xhr.onload = (evt)=>
        console.log('开始上传blob')
        status = xhr.status

        if (status >= 200 && status < 300 || status == 304)
          res = jQuery.string(xhr.responseText).evalJSON()

          @uploaded_byte = res.saved_size

          console.log('比较已上传，文件本身的大小',
                  @uploaded_byte,
                  @file.size,
                  @is_uploading_finished())

          @inform_or_upload()
        else
          console.log('blob上传出错:' + status)
          @show_error()


      xhr.upload.onprogress = (evt)=>
        loaded = evt.loaded
        total  = evt.total

        uploaded_byte = @uploaded_byte + loaded
        file_size     = @file.size

        # 计算上传百分比
        percent_uploaded = (uploaded_byte * 100 / file_size).toFixed(2)
        @set_progress(percent_uploaded)

        # 计算上传速度
        new_time = new Date()
        time_delta = new_time - @last_refreshed_time

        #console.log(new_time, 2, @last_refreshed_time)

        if time_delta > 500
          size_delta = loaded

          @last_refreshed_time = new_time
          @set_speed(size_delta / time_delta)

      xhr.send(@._get_form_data())

    is_uploading_finished: ->
      @uploaded_byte >= @file.size



    query_md5: ->
      if @MD5
        jQuery.ajax
          url  : @MD5_QUERY_URL
          type : 'GET'
          data : { 'md5' : @MD5 }
          success : (data)=> #返回应该是一个字符串，media_file_id或空

            # 根据返回来判断是否同md5的media_file已存在
            # 如果已存在就告知psu服务器inform_psu_exist
            
            # 如果未存在就什么也不作
            @EXISTING_MEDIA_FILE_ID = data

            console.log('query md5 data: ', data)
            console.log('看看有没有existing_media_file_id ', @EXISTING_MEDIA_FILE_ID)
            console.log('url', @MD5_QUERY_URL)
            console.log('data', data)
          error : @show_error
      
        return

      console.log('MD5值未算出！')


    file_put: ->
      jQuery.ajax
        url  :  @FILE_PUT_URL
        type : 'POST'
        data : 
          'file_name' : @file.name
          'slice_temp_file_id' : @SLICE_TEMP_FILE_ID

        success : (res)-> #返回应该是一个字符串，新的media_file_id
          console.log('inform返回: ', arguments)
          attachment_id_field = $('.hidden.attachment-ids input').clone()

          attachment_id_field.val(res)
          $('.assign_form').append(attachment_id_field)

        error : @show_error


    get_blob: ->
      @slice_file(@uploaded_byte)


    slice_file: (start_byte)->
      File.prototype.mindpin_slice = File.prototype.slice ||
                                     File.prototype.webkitSlice ||
                                     File.prototype.mozSlice

      return @file.mindpin_slice(start_byte, start_byte + @BLOB_SIZE)


    get_size_str: ->
      mbs  = @file.size / 1024 / 1024
      return "#{(Math.floor(mbs * 100) / 100)} + MB"

    set_progress: (percent)->
      @elm
        .find('.bar .percent')
          .html(percent + ' %')
        .end()
        .find('.bar .p')
          #.animate({'width':percent+'%'}, 100)
          .css({'width':percent+'%'})

    set_speed: (speed)->
      @elm
        .find('.speed .data')
          .html( speed.toFixed(2) + 'KB/s')
        .end()
        .find('.remaining-time .data')
          .html( '--:--:--' )
        .end()

    render: ->
      @set_progress(0)
      @set_speed(0)

      @elm
        .find('.name')
          .html(jQuery.string(@file.name).escapeHTML().str)
        .end()
        .find('.size')
          .html( @get_size_str() )
        .end()

        .hide()
        .fadeIn(100)
        .appendTo(UPLOADER_ELM.find('.uploading-files-list'))

      return this

    # 以下为MD5相关方法：

    get_md5: ->
      file_reader = new FileReader
      spark       = new SparkMD5()

      file_reader.onload = (evt)=>
        spark.appendBinary(evt.target.result)

        if @read_byte < @file.size
          next_blob()
          return

        @MD5 = spark.end()
        console.log('获得MD5值为: ', @MD5)

        @elm.find('.md5').text('MD5: ' + @MD5)

        @query_md5()

      file_reader.onprogress = (evt)=>
        # 增加进度显示
        loaded = evt.loaded
        total  = evt.total

        read_byte = @read_byte + loaded
        file_size = @file.size

        percent_read = (read_byte * 100 / file_size).toFixed(2)
        percent_read = percent_read > 100 ? 100 : percent_read

        @elm.find('.md5-percent').text( percent_read + '%' )

      next_blob = =>
        file_reader.readAsBinaryString(@slice_file(@read_byte))
        @read_byte += @BLOB_SIZE

      next_blob()

  # 收到文件数组，执行上传
  upload_each_files = (files)->
    jQuery.each files, (index, file)->
      # TODO 这里需要加入文件是否重复上传的判断

      new HomeworkAttachment(file).render().start_upload()


  # --------------------------
  # 一些小函数，都是关于事件绑定的，比较繁琐，主要逻辑看上面就可以了

  # 停止事件冒泡并阻止浏览器默认行为
  stop_event = (evt)->
    evt.stopPropagation()
    evt.preventDefault()

  show_dragover = ->
    UPLOADER_ELM.find('.upload-drop-area .tip').addClass('dragover')

  hide_dragover = ->
    UPLOADER_ELM.find('.upload-drop-area .tip').removeClass('dragover')

  is_in_body = (dom)->
    try
      return (dom == document.body) || jQuery.contains(document.body, dom)
    catch e
      return false

  # ----------------------------
  # ----- 以下为事件绑定：

  UPLOADER_ELM.find('input[type=file]').live 'change', (evt)->
    upload_each_files(evt.target.files)

  jQuery(document.body)
    .bind('dragover', (evt)-> stop_event(evt))

    .bind('dragenter', (evt)->
      #console.log(evt.target, evt.relatedTarget)
      stop_event(evt)
      show_dragover())

    .bind('dragleave', (evt)->
      stop_event(evt)
      if jQuery.browser.mozilla
        if !is_in_body(evt.relatedTarget)
          hide_dragover()
        return

      oevt = evt.originalEvent
      if oevt.clientX <= 0 || oevt.clientY <= 0
        hide_dragover())

    .bind('drop', (evt)->
      stop_event(evt)
      hide_dragover()
      upload_each_files(evt.originalEvent.dataTransfer.files))
