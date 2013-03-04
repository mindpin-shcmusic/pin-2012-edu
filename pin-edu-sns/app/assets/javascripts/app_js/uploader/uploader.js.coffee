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
    @close          = options.close || ->

    @bind_button()

    File::mindpin_slice = 
      File::slice ||
      File::webkitSlice ||
      File::mozSlice

  bind_button: ->
    that = this

    @$button.find('input[type=file]').live 'change', (evt)->
      files = evt.target.files
      jQuery.each files, (index, file)=>
        new FileUploadWrapper(that, file).render().upload()

class FileUploadWrapper
  constructor: (uploader, file)->
    @uploader = uploader
    @file = file

    @file_name = @file.name
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

  close: ->
    @cancel = true
    @xhr.abort()
    @uploader.close(@$elm)

  get_size_str: ->
    mbs = @file_size / 1024 / 1024
    return "#{Math.floor(mbs * 100) / 100}MB"

  upload: ->
    if 0 == @file_size
      @error '请不要上传空文件'
      return

    @last_refreshed_time = new Date

    @xhr.open 'POST', @uploader.UPLOAD_URL, true
    @xhr.send @build_form_data()

  xhr_onload: (evt)=>
      status = @xhr.status

      if status >= 200 && status < 300 || status == 304
        res = jQuery.string(@xhr.responseText).evalJSON()
        @uploaded_size = res.saved_size
        @FILE_ENTITY_ID = @FILE_ENTITY_ID || res.file_entity_id

        @continue()
      else
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

  build_form_data: ->
    form_data = new FormData
    form_data.append 'name', @file_name
    form_data.append 'size', @file_size
    if @FILE_ENTITY_ID
      form_data.append 'file_entity_id', @FILE_ENTITY_ID
    
    form_data.append 'blob', @get_next_blob()
    return form_data

  continue: ->
    return if @cancel == true

    if @is_finished()
      @set_progress(100)
      @success()
      return

    @set_progress_on_upload()
    @upload()

  is_finished: ->
    return @uploaded_size >= @file.size

  get_next_blob: ->
    start_byte = @uploaded_size
    end_byte   = start_byte + @uploader.BLOB_SIZE

    return @file.mindpin_slice(start_byte, end_byte)



# 媒体资源
pie.load ->
  
  $upload_button = jQuery('.page-media-resource-head .page-upload-button')
  $uploader_elm = jQuery('.page-media-file-uploader')

  if $upload_button.exists() && $uploader_elm.exists()

    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->
        # 显示上传框
        pie.open_fbox 'upload_resource'

        # 添加上传进度条
        $file = $uploader_elm.find('.progress-bar-sample .file').clone()
        $list = $uploader_elm.find('.uploading-files-list').append($file)

        $file.find('.name').html file_wrapper.file_name
        $file.find('.size').html file_wrapper.get_size_str()

        $file.find('a.close').click ->
          file_wrapper.close()

        $file
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file

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
        file_path = jQuery.path_join(CURRENT_PATH, file_name)

        file_wrapper.$elm.addClass 'success'
        file_wrapper.$elm.find('.state').html '上传完毕'

        jQuery.ajax
          url:  FILE_PUT_URL
          type: 'PUT'
          data:
            'path' : file_path
            'file_entity_id' : file_wrapper.FILE_ENTITY_ID

          success: (res)->
            $list = jQuery('.page-media-resources')
            $resource = jQuery(res).find('.media-resource')
            id = $resource.data('id')

            $list.find('.media-resource-blank').remove()
            $list.find(".media-resource[data-id=#{id}]").remove()
            $list.prepend $resource

            jQuery(document).trigger('ajax:create-resource')

          error: ->
            file_wrapper.error()

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.state').html msg || '上传出错'

      close: ($wrapper)->
        $wrapper.addClass 'cancel'
        $wrapper.find('.state').html '已取消'




# 管理员上传多级目录资源
pie.load ->
  
  $upload_button = jQuery('.page-upload-document-head .page-upload-button')
  $uploader_elm = jQuery('.page-media-file-uploader')

  if $upload_button.exists() && $uploader_elm.exists()

    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->
        # 显示上传框
        pie.open_fbox 'upload_resource'

        # 添加上传进度条
        $file = $uploader_elm.find('.progress-bar-sample .file').clone()
        $list = $uploader_elm.find('.uploading-files-list').append($file)

        $file.find('.name').html file_wrapper.file_name
        $file.find('.size').html file_wrapper.get_size_str()

        $file.find('a.close').click ->
          file_wrapper.close()

        $file
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file

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
        FILE_PUT_URL = '/admin/upload_documents/file_put'
        dir_id = $uploader_elm.data('dir-id')
        file_name = file_wrapper.file_name

        file_wrapper.$elm.addClass 'success'
        file_wrapper.$elm.find('.state').html '上传完毕'

        jQuery.ajax
          url:  FILE_PUT_URL
          type: 'POST'
          data:
            'upload_document[file_entity_id]' : file_wrapper.FILE_ENTITY_ID
            'upload_document[dir_id]' : dir_id
            'upload_document[file_name]' : file_name

          success: (res)->
            $cells = jQuery(res).find('.cells')[0]
            jQuery('.admin-upload-document-files').prepend($cells)

          error: ->
            file_wrapper.error()

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.state').html msg || '上传出错'

      close: ($wrapper)->
        $wrapper.addClass 'cancel'
        $wrapper.find('.state').html '已取消'




# -------------------
# 作业附件上传
pie.load ->

  $upload_button = jQuery('.page-model-form.homework .page-upload-button')

  if $upload_button.exists()
    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->        
        # 添加上传进度条
        $file = jQuery('.page-model-form.homework .field.attachments .sample.hide .file').clone()
        $list = jQuery('.page-model-form.homework .field.attachments')

        $file.find('.name').html file_wrapper.file_name

        $file.find('a.close').click ->
          file_wrapper.close()

        $file
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file

      set_progress: ($wrapper, percent)->
        pstr = "#{percent}%"

        $wrapper.find('.percent').html(pstr)

        if 0 == percent
          $wrapper.find('.bar .p').css('width', pstr)
        else
          $wrapper.find('.bar .p').animate({'width': pstr}, 100)

      success: (file_wrapper)->
        file_entity_id = file_wrapper.FILE_ENTITY_ID

        file_wrapper.$elm.find('input.fid').val(file_entity_id)
        file_wrapper.$elm.find('input.fname').val(file_wrapper.file_name)
        file_wrapper.$elm.addClass 'complete'

      close: ($wrapper)->
        $wrapper.remove()


# --------------
# 作业提交物上传
pie.load ->
  $upload_buttons = jQuery('.page-model-show.homework .page-upload-button')

  $upload_buttons.each ->
    $button = jQuery(this)

    uploader = new FileUploader $button,
      render: (file_wrapper)->
        # 添加上传进度条
        $file_elm = $button.closest('.requirement')
        $file_elm
          .removeClass('complete')
          .removeClass('error')
          .addClass('uploading')
        $file_elm.find('.name').html file_wrapper.file_name

        return $file_elm

      set_progress: ($wrapper, percent)->
        pstr = "#{percent}%"

        $wrapper.find('.percent').html(pstr)

        if 0 == percent
          $wrapper.find('.bar .p').css('width', pstr)
        else
          $wrapper.find('.bar .p').animate({'width': pstr}, 100)

      success: (file_wrapper)->
        file_entity_id = file_wrapper.FILE_ENTITY_ID

        URL = '/homeworks/create_student_upload'
        requirement_id = file_wrapper.$elm.data('id')

        jQuery.ajax
          url: URL
          type: 'POST'
          data:
            requirement_id: requirement_id
            name: file_wrapper.file_name
            file_entity_id: file_entity_id
          success: (res)->
            file_wrapper.$elm.addClass('complete').removeClass('uploading')
            if res.all_completed
              file_wrapper.$elm.closest(".page-model-show.homework").find('.student-submit').show()
          error: ->
            file_wrapper.error()

      error: ($wrapper, msg)->
        $wrapper
          .removeClass('complete')
          .removeClass('uploading')
          .addClass('error')


# -------------
# 课程照片、视频上传

pie.load ->
  
  $upload_button = jQuery('.page-course-show .page-upload-button')
  $uploader_elm = jQuery('.page-media-file-uploader')

  if $upload_button.exists() && $uploader_elm.exists()

    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->
        # 显示上传框
        pie.open_fbox 'upload_resource'

        # 添加上传进度条
        $file = $uploader_elm.find('.progress-bar-sample .file').clone()
        $list = $uploader_elm.find('.uploading-files-list').append($file)

        $file.find('.name').html file_wrapper.file_name
        $file.find('.size').html file_wrapper.get_size_str()

        $file.find('a.close').click ->
          file_wrapper.close()

        $file
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file

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
        # 创建课程图片记录
        course_id = $uploader_elm.data('course-id')
        kind = $uploader_elm.data('kind')
        semester_value = $uploader_elm.data('semester_value')
        url = "/courses/#{course_id}/course_resources"

        file_wrapper.$elm.addClass 'success'
        file_wrapper.$elm.find('.state').html '上传完毕'

        jQuery.ajax
          url:  url
          type: 'POST'
          data:
            'file_entity_id': file_wrapper.FILE_ENTITY_ID
            'name': file_wrapper.file_name
            'kind': kind
            'semester_value': semester_value

          success: (res)->
            # $list = jQuery('.page-media-resources')
            # $resource = jQuery(res).find('.media-resource')
            # id = $resource.data('id')

            # $list.find('.media-resource-blank').remove()
            # $list.find(".media-resource[data-id=#{id}]").remove()
            # $list.prepend $resource

            # jQuery(document).trigger('ajax:create-resource')

          error: ->
            file_wrapper.error()

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.state').html msg || '上传出错'

      close: ($wrapper)->
        $wrapper.addClass 'cancel'
        $wrapper.find('.state').html '已取消'

# -----
# 管理员界面图片，课件上传
pie.load ->

  

  jQuery('.page-admin-course .detail.images').each ->
    $this = jQuery(this)
    $upload_button = $this.find('.page-upload-button')
    $uploader_elm = $this.find('.page-media-file-uploader')
    jfbox_id = $uploader_elm.closest('.page-float-box').data('jfbox-id')

    uploader = new FileUploader $upload_button,
      render: (file_wrapper)->
        # 显示上传框
        pie.open_fbox jfbox_id

        # 添加上传进度条
        $file = $uploader_elm.find('.progress-bar-sample .file').clone()
        $list = $uploader_elm.find('.uploading-files-list').append($file)

        $file.find('.name').html file_wrapper.file_name
        $file.find('.size').html file_wrapper.get_size_str()

        $file.find('a.close').click ->
          file_wrapper.close()

        $file
          .hide()
          .fadeIn(100)
          .appendTo $list

        return $file

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
        # 创建课程图片记录
        course_id = $uploader_elm.data('course-id')
        kind = $uploader_elm.data('kind')
        semester_value = $uploader_elm.data('semester_value')
        url = "/admin/courses/#{course_id}/course_resources"

        file_wrapper.$elm.addClass 'success'
        file_wrapper.$elm.find('.state').html '上传完毕'

        jQuery.ajax
          url:  url
          type: 'POST'
          data:
            'file_entity_id': file_wrapper.FILE_ENTITY_ID
            'name': file_wrapper.file_name
            'kind': kind
            'semester_value': semester_value

          success: (res) ->
            pie.close_fbox(jfbox_id)
            $this.find(".images").prepend(res)
          error: ->
            file_wrapper.error()

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.state').html msg || '上传出错'

      close: ($wrapper)->
        $wrapper.addClass 'cancel'
        $wrapper.find('.state').html '已取消'


# -----
# 管理员界面，学生毕业归档附件上传
pie.load ->
  $upload_attachment = jQuery('.page-admin-students .upload-attachment')
  if $upload_attachment.exists()
    $upload_attachment.each ->
      $this_ele = jQuery(this)
      $upload_button = $this_ele.find('.page-upload-button')
      $uploader_elm = $this_ele.find('.page-media-file-uploader')
      jfbox_id = $this_ele.find('.page-float-box').data('jfbox-id')

      uploader = new FileUploader $upload_button,
        render: (file_wrapper)->
          # 显示上传框
          pie.open_fbox jfbox_id

          # 添加上传进度条
          $file = $uploader_elm.find('.progress-bar-sample .file').clone()
          $list = $uploader_elm.find('.uploading-files-list').append($file)

          $file.find('.name').html file_wrapper.file_name
          $file.find('.size').html file_wrapper.get_size_str()

          $file.find('a.close').click ->
            file_wrapper.close()

          $file
            .hide()
            .fadeIn(100)
            .appendTo $list

          return $file

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
          # 创建和学生的关联
          student_id = $uploader_elm.data('student-id')
          kind = $uploader_elm.data('kind')
          url = "/admin/students/#{student_id}/upload_attachment"

          file_wrapper.$elm.addClass 'success'
          file_wrapper.$elm.find('.state').html '上传完毕'

          jQuery.ajax
            url:  url
            type: 'PUT'
            data:
              'file_entity_id': file_wrapper.FILE_ENTITY_ID
              'name': file_wrapper.file_name
              'kind': kind

            error: ->
              file_wrapper.error()

        error: ($wrapper, msg)->
          $wrapper.addClass 'error'
          $wrapper.find('.state').html msg || '上传出错'

        close: ($wrapper)->
          $wrapper.addClass 'cancel'
          $wrapper.find('.state').html '已取消'


#--------------------- 演示 教学方案 的章节编辑页面 上传课件
pie.load ->
  return if !jQuery('.page-zhangjie-edit .desc-info').exists()

  add_course_ware_upload_file = ->
    $upload_kejian = jQuery('.page-zhangjie-edit .kejian-file')
    $upload_kejian.each ->
      $this_ele = jQuery(this)
      return if $this_ele.data('loaded_add_course_ware_upload_file')
      $this_ele.data('loaded_add_course_ware_upload_file',true)

      $upload_button = $this_ele.find('.page-upload-button')
      $uploader_elm = $this_ele.find('.page-media-file-uploader')
      jfbox_id = $uploader_elm.closest('.page-float-box').data('jfbox-id')
      $kejian_list = $this_ele.find('.kejian-list')

      uploader = new FileUploader $upload_button,
        render: (file_wrapper)->
          # 显示上传框
          pie.open_fbox jfbox_id

          # 添加上传进度条
          $file = $uploader_elm.find('.progress-bar-sample .file').clone()
          $list = $uploader_elm.find('.uploading-files-list').append($file)

          $file.find('.name').html file_wrapper.file_name
          $file.find('.size').html file_wrapper.get_size_str()

          $file.find('a.close').click ->
            file_wrapper.close()

          $file
            .hide()
            .fadeIn(100)
            .appendTo $list

          return $file

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
          course_ware_id = $uploader_elm.data('course_ware_id')
          url = "/course_wares/#{course_ware_id}/upload_file"
          jQuery.ajax
            url:  url
            type: 'PUT'
            data:
              'file_entity_id': file_wrapper.FILE_ENTITY_ID
              'file_name': file_wrapper.file_name
            success: (res)->
              pie.close_fbox(jfbox_id)
              $this_ele.find('> .file').html(res)
        

      error: ($wrapper, msg)->
        $wrapper.addClass 'error'
        $wrapper.find('.state').html msg || '上传出错'

      close: ($wrapper)->
        $wrapper.addClass 'cancel'
        $wrapper.find('.state').html '已取消'

  add_course_ware_upload_file()
  jQuery(document).on('chapter:add_course_ware',add_course_ware_upload_file)