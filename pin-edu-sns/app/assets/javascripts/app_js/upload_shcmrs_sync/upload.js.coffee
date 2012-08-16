# 文件上传的事件绑定

pie.load ->
  class FileUploader
    constructor: ($uploader_elm)->
      @$elm = $uploader_elm

      @BLOB_SIZE = 524288; # 1024 * 512 bytes 512K / 每段
      @UPLOAD_URL = @$elm.data 'new-upload-url'

      @bind()

    bind: ->
      that = this

      @$elm.find('input[type=file]').live 'change', (evt)->
        files = evt.target.files

        jQuery.each files, (index, file)=>
          # TODO 这里需要加入文件是否重复上传的判断
          new FileWrapper(that, file).render().upload()

    build_wrapper_elm: ->
      @$elm.find('.progress-bar-sample .file').clone()

    get_list_elm: ->
      @$elm.find('.uploading-files-list')


  class FileWrapper
    constructor: (uploader, file)->
      @uploader = uploader
      @file = file

      @$elm = @uploader.build_wrapper_elm()

      @file_name = jQuery.string(@file.name).escapeHTML().str
      @file_size = @file.size
      @uploaded_size = 0

    render: ->
      @init_name()
      @init_size()
      @init_append()

      @set_progress(0)
      @set_speed(0)

      return this

    get_size_str: ->
      mbs = @file_size / 1024 / 1024
      return "#{Math.floor(mbs * 100) / 100}MB"

    init_name: ->
      @$elm.find('.name').html @file_name

    init_size: ->
      @$elm.find('.size').html @get_size_str()

    init_append: ->
      @$elm
        .hide()
        .fadeIn(100)
        .appendTo uploader.get_list_elm()

    set_progress: (percent)->
      pstr = "#{percent}%"

      @$elm
        .find('.percent')
          .html(pstr)
        .end()

        .find('.bar .p')
          .css('width', pstr)

    set_speed: (speed)->
      @$elm
        .find('.speed')
          .html("#{speed.toFixed(1)}KB/s")
        .end()

    show_error: (msg)->
      @$elm.addClass 'error'
      @$elm.find('.error').append msg || ''

    upload: ->
      if 0 == @file_size
        @show_error '请不要上传空文件'
        return

      @last_refreshed_time = new Date()

      xhr = new XMLHttpRequest

      xhr.onload = (evt)=>
        console.log '开始上传blob'
        status = xhr.status
        if status >= 200 && status < 300 || status == 304
          res = jQuery.string(xhr.responseText).evalJSON()
          @uploaded_byte = res.saved_size

          console.log "文件大小: #{@file.size}"
          console.log "已上传: #{@uploaded_byte}"

          @continue()
        else
          console.log "blob上传出错: #{status}"
          @show_error()

      xhr.upload.onprogress = (evt)->
        loaded = evt.loaded
        total  = evt.total

        uploaded_byte = @uploaded_byte + loaded
        file_size     = @file.size

        # 计算上传百分比
        percent_uploaded = (uploaded_byte * 100 / @file_size).toFixed(1)
        @set_progress(percent_uploaded);

        # 计算上传速度
        new_time = new Date()
        time_delta = new_time - @last_refreshed_time

        if time_delta > 500
          size_delta = loaded

          @last_refreshed_time = new_time
          @set_speed size_delta / time_delta

      xhr.open 'POST', @UPLOAD_URL, true
      xhr.send @get_form_data()

    get_form_data: ->
      form_data = new FormData
      form_data.append 'name', @file_name
      form_data.append 'size', @file_size
      form_data.append 'blob', @get_blob()

      if @SLICE_TEMP_FILE_ID
        form_data.append 'slice_temp_file_id', @SLICE_TEMP_FILE_ID
      
      return form_data

    continue: ->
      if @is_finished()
        console.log '上传完毕'
        @file_put()
        @set_progress(100)
        return

      @upload()

    is_finished: ->
      return @uploaded_byte >= @file.size

#       this.file_put = function() {
#         var url = jQuery.path_join(this.FILE_PUT_URL,this.CURRENT_PATH,this.file.name)
#         console.log(url)
#         jQuery.ajax({
#           url  :  url,
#           type : 'PUT',
#           data : {
#             'slice_temp_file_id' : this.SLICE_TEMP_FILE_ID
#           },
#           success : function(data){ //返回应该是一个字符串，新的media_file_id
#             console.log('inform返回: ', arguments);
#           },
#           error : _this.show_error
#         });
#       }

    get_blob: ->
      return @slice_file()

    slice_file: (start_byte)->
      File.prototype.mindpin_slice = 
        File.prototype.slice ||
        File.prototype.webkitSlice ||
        File.prototype.mozSlice

      return @file.mindpin_slice(start_byte, start_byte + @BLOB_SIZE)

  $uploader_elm = jQuery('.page-media-file-uploader')

  if $uploader_elm.exists()
    uploader = new FileUploader($uploader_elm)