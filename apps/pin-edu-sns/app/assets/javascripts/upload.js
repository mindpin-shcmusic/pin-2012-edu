var CHUNK_SIZE = 1048576;
var existing_files = [];
var file_url = 'http://dev.uploadmediafile.yinyue.edu/new_upload';
var blob_url = 'http://dev.uploadmediafile.yinyue.edu/upload_blob';
var creator_id = $('input[name=creator_id]').attr('value');


var stopDefaultEvent = function(e) {
  e.stopPropagation();
  e.preventDefault();
}

var slicer = function(file, start_byte, end_byte) {
  File.prototype.slice = File.prototype.webkitSlice || File.prototype.mozSlice;
  return file.slice(start_byte, end_byte);
}

var send_file_meta = function(file) {
  console.log('发送文件信息');
  $.ajax({
    url: file_url,
    type: 'POST',
    data: {
      'file_name': file.name,
      'file_size': file.size,
      'creator_id': creator_id
    },
    success: function(res) {
      console.log('文件返回', res);
      var start_byte = parseInt(res);
      var end_byte = start_byte + CHUNK_SIZE;

      upload_part(file, start_byte, end_byte);
    },
    error: function() {
      console.log('发送文件信息失败');
      console.log(arguments);
    }
  });
}

var upload_part = function(file, start_byte, end_byte) {
  var file_mb = convert_size(file.size / 1049015);

  if (start_byte >= file.size) {
    file_progress(file).css({
      'width': '100%',
      'background': 'green'
    });

    file_percent(file).text('100%');

    file_saved_size(file).text(
      file_mb + 'mb / ' + file_mb + 'mb'
    );

    if (file.media_id) {
      do_category_options(file);
    } else {
      $('.' + file.id).append($('<span class=uploaded>资源已存在！</span>'));
      $('.uploaded').css({'color': 'red'});
    }

    return;
  }

  var xhr = new XMLHttpRequest;
  var formdata = new FormData;
  var blob = slicer(file, start_byte, end_byte);

  console.log('准备传blob', file,start_byte,end_byte,blob);

  formdata.append('file_name', file.name);
  formdata.append('file_size', file.size);
  formdata.append('file_blob', blob);
  formdata.append('creator_id', creator_id);

  xhr.open('POST', blob_url, true);
  xhr.onload = function(e) {
    var status = xhr.status;
    console.log('blob上传完毕返回http code', status);
    if (status >= 200 && status < 300 || status === 304) {
      var res = xhr.responseText;
      res = $.string(res).evalJSON();
      var media_file_id;
      var start_byte = parseInt(res.saved_size);
      var end_byte = start_byte + CHUNK_SIZE;

      if (res.media_file) {
        media_file_id = res.media_file.id;
      }

      if (media_file_id) file.media_id = media_file_id;
      console.log('媒体资源ID', media_file_id, file.media_id);

      upload_part(file, start_byte, end_byte);
    } else {
      console.log('blob上传出错' + status);
    }
  }

  xhr.upload.onprogress = function(e) {
    console.log('blob上传进度', start_byte, e.loaded, e.total);
    var percent_complete = Math.round((start_byte+e.loaded)*100 / file.size);
    var saved_mb = convert_size((start_byte + e.loaded) / 1049015);

    file_progress(file).animate({'width': percent_complete + '%'}, 0);
    file_percent(file).text(percent_complete + '%');
    file_saved_size(file).text(
      saved_mb + 'mb / ' + file_mb + 'mb'
    );
  }

  xhr.send(formdata);
}

var convert_size = function(size) {
  if (size < 0.01) {
    return size.toPrecision(2);
  } else {
    return size.toFixed(2);
  }
}

var slugify = function(text) {
  text = text.replace(/[^-a-zA-Z0-9,&\s]+/ig, '');
  text = text.replace(/-/gi, "_");
  text = text.replace(/\s/gi, "-");
  return text;
}

var FileWrapper = function(file) {
  var elm = $(
    '<li class="file ' + file.id +  '">' +
    '<strong>' +
    $.string(file.name).escapeHTML().str + '</strong>' +
    '<span class=file-type>(' + (file.type || 'n/a') + ')</span>' +
    '<span class=percent></span>' +
    '<span class=saved-size></span>' +
    '<span class=uploaded>资源已存在！</span>' +
    '<div class=status></div>' +
    '<div class=progress-wrapper><div class=progress></div></li></div>'
  );

  this.render = function() {
    elm.find('.uploaded').css({'color': 'red'}).hide();
    $('.files-list').append(elm);
  }

  this.__defineGetter__('file', function() {
    return file;
  });

  console.log('文件元素', this, file);
}

FileWrapper.get_elm = function(file) {
  return $('.' + file.id);
}

FileWrapper.get_children = function(file, selector) {
  return this.get_elm(file).find(selector);
}

var file_progress = function(file) {
  return FileWrapper.get_children(file, '.progress');
}

var file_percent = function(file) {
  return FileWrapper.get_children(file, '.percent');
}

var file_saved_size = function(file) {
  return FileWrapper.get_children(file, '.saved-size');
}

var do_category_options = function(file) {
  var form = $('.hidden form').clone().attr({
    action: '/media_files/' + file.media_id,
    class: 'edit_media_file',
    id: 'edit_media_file_' + file.media_id,
    'data-remote': 'true',
    'date-method': 'put',
    'method': 'put'
  }).append('<input name="_method" type="hidden" value="put" />');

  FileWrapper.get_elm(file).append(form)
}

$('form[data-remote]').live('ajax:complete', function(jqxhr, xhr) {
  var status = xhr.status;
  if (status >= 200 && status < 300 || status === 304) {
    $(this).css({'background': 'green'});
  } else {
    $(this).css({'background': 'red'});
    alert('分类保存失败，请选择空分类或者叶子分类！');
  }
});

var iterateFiles = function(files) {
  $.each(files, function(index, file) {
    file.id = slugify(file.name);
    var file_wrapper = new FileWrapper(file);

    if (existing_files.indexOf(file.name) != -1) {
      alert('文件正在传输，请不要重复添加文件');
      return;
    }

    existing_files.push(file.name);
    console.log(existing_files)
    file_wrapper.render();
    send_file_meta(file);
  });
}

var fileSelectUpload = function(e) {
  var files = e.target.files;
  iterateFiles(files);
}

var handleDragover = function(e) {
  stopDefaultEvent(e);
  e.dataTransfer.dropEffect = 'copy';
}

var dropUpload = function(e) {
  stopDefaultEvent(e);
  var files = e.dataTransfer.files;
  iterateFiles(files);
}

$('input[type=file]').on('change', fileSelectUpload);
document.body.addEventListener('dragover', handleDragover, false);
document.body.addEventListener('drop', dropUpload, false);
