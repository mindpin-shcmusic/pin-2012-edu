// 文件上传的事件绑定
pie.load(function(){
  var file_uploader_elm = jQuery('.page-media-file-uploader');
  if(0 == file_uploader_elm.length) return;


  var FileWrapper = function(file) {
    this.BLOB_SIZE      = 524288; // 1024 * 512 bytes 512K传一段
    this.NEW_UPLOAD_URL = file_uploader_elm.domdata('new-upload-url');
    this.SEND_BLOB_URL  = file_uploader_elm.domdata('send-blob-url');
    this.CREATOR_ID     = file_uploader_elm.domdata('creator-id');
    
    this.file = file;
    this.elm  = file_uploader_elm.find('.progress-bar-sample .file').clone();

    this.uploaded_byte = 0;

    var _this = this;

    this.show_error = function(){
      this.elm.addClass('error');
    }

    this.start_upload = function(){
      jQuery.ajax({
        url  : this.NEW_UPLOAD_URL,
        type : 'POST',
        data : {
          'file_name'  : this.file.name,
          'file_size'  : this.file.size,
          'creator_id' : this.CREATOR_ID
        },
        success : function(res){
          _this.uploaded_byte = ~~res;
          _this.upload_blob();
        },
        error : function(){
          _this.show_error();
        }
      })
    }

    this._get_form_data = function(){
      var form_data = new FormData;

      form_data.append('file_name',  this.file.name);
      form_data.append('file_size',  this.file.size);
      form_data.append('file_blob',  this.get_blob());
      form_data.append('creator_id', this.CREATOR_ID);

      return form_data;
    }

    // 上传文件段
    this.upload_blob = function() {
      if (this.uploaded_byte >= this.file.size) {
        pie.log('上传完毕');

        this.set_progress('100.00');
        return;
      }

      var xhr = new XMLHttpRequest;

      xhr.open('POST', this.SEND_BLOB_URL, true);

      xhr.onload = function(evt) {
        var status = xhr.status;

        if (status >= 200 && status < 300 || status === 304) {
          var res = jQuery.string(xhr.responseText).evalJSON();

          _this.uploaded_byte = ~~res.saved_size;
          _this.upload_blob();
        } else {
          pie.log('blob上传出错:' + status);
          _this.show_error();
        }
      }

      xhr.upload.onprogress = function(evt) {
        var loaded = evt.loaded;
        var total  = evt.total;

        var uploaded_byte = _this.uploaded_byte + loaded;
        var file_size     = _this.file.size

        var percent_uploaded = (uploaded_byte * 100 / file_size).toFixed(2);

        _this.set_progress(percent_uploaded);
      }

      xhr.send(this._get_form_data());
    }

    this.get_blob = function(){
      File.prototype.mindpin_slice = File.prototype.webkitSlice || File.prototype.mozSlice;
      return this.file.mindpin_slice(this.uploaded_byte, this.uploaded_byte + this.BLOB_SIZE);
    }

    this.get_size_str = function(){
      var mbs  = this.file.size/1024/1024;
      mbs = ~~(mbs * 100) / 100;
      return mbs + "MB";
    }

    this.set_progress = function(percent){
      this.elm
        .find('.bar .percent')
          .html(percent + ' %')
        .end()
        .find('.bar .p')
          //.animate({'width':percent+'%'}, 100)
          .css({'width':percent+'%'})
    }

    this.set_speed = function(speed){
      this.elm
        .find('.speed .data')
          .html( speed + 'KB/s')
        .end()
        .find('.remaining-time .data')
          .html( '--:--:--' )
        .end()
    }

    this.render = function() {
      this.set_progress(0);
      this.set_speed(0);

      this.elm
        .find('.name')
          .html(jQuery.string(this.file.name).escapeHTML().str)
        .end()
        .find('.size')
          .html( this.get_size_str() )
        .end()

        .hide()
        .fadeIn(100)
        .appendTo(file_uploader_elm.find('.uploading-files-list'));

      return this;
    }
  }

  // 收到文件数组，执行上传
  var upload_each_files = function(files) {
    jQuery.each(files, function(index, file) {
      // TODO 这里需要加入文件是否重复上传的判断

      new FileWrapper(file).render().start_upload();
    });
  }


  // -------
  // 一些小函数，都是关于事件绑定的，比较繁琐，主要逻辑看上面就可以了

  // 停止事件冒泡并阻止浏览器默认行为
  var stop_event = function(evt){
    evt.stopPropagation();
    evt.preventDefault();
  }

  var show_dragover = function(){
    file_uploader_elm.find('.upload-drop-area .tip').addClass('dragover');
  }

  var hide_dragover = function(){
    file_uploader_elm.find('.upload-drop-area .tip').removeClass('dragover');
  }

  var is_in_body = function(dom){
    try{
      return (dom == document.body) || jQuery.contains(document.body, dom)
    }catch(e){
      return false;
    }
  }

  // ----- 以下为事件绑定

  file_uploader_elm.find('input[type=file]').live('change', function(evt){
    upload_each_files(evt.target.files);
  });

  jQuery(document.body)
    .bind('dragover', function(evt){ stop_event(evt); })

    .bind('dragenter', function(evt){
      //pie.log(evt.target, evt.relatedTarget);
      stop_event(evt);
      show_dragover();
    })

    .bind('dragleave', function(evt){
      stop_event(evt);
      if(jQuery.browser.mozilla){
        if(!is_in_body(evt.relatedTarget)){ hide_dragover(); }
        return;
      }

      var oevt = evt.originalEvent;
      if( oevt.clientX <= 0 || oevt.clientY <= 0){ hide_dragover(); }
    })

    .bind('drop', function(evt){
      stop_event(evt);
      hide_dragover();
      upload_each_files(evt.originalEvent.dataTransfer.files);
    })

});