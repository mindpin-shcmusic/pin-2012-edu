$(function(){
    $.event.props.push('dataTransfer');
  var creator_id = $('input[name=creator_id]').attr('value'),
	    request_url = 'http://dev.uploadmediafile.yinyue.edu/upload?creator_id=' + creator_id,
      files_list = $('.files_list'),
      files;

  var do_file_elm = function(file) {
    return $(
      '<li class="file ' + file.id +  '">' +
      '<strong>' +
      $.string(file.name).escapeHTML().str + '</strong>' +
      '<span class="file_type">(' + (file.type || 'n/a') + ')</span>' +
      '<div class=status></div>' +
      '<div class="progress-wrapper"><div class="progress"></div></li></div>'
    );
  }

  var do_categories = function(file_status) {
    var categories = $('.categories').clone().removeClass("hidden");
    file_status.html(categories);
  }

  var slugify = function(text) {
    text = text.replace(/[^-a-zA-Z0-9,&\s]+/ig, '');
    text = text.replace(/-/gi, "_");
    text = text.replace(/\s/gi, "-");
    return text;
  }

  $('body, input[type=file]').html5Uploader({
    name: 'file',
    postUrl: request_url,
    onClientLoadStart: function(e, f) {
			console.log("on client load start")
      f.id = slugify(f.name);
			files_list.append(do_file_elm(f));
    },
    onServerProgress: function(e, f) {
			console.log("onServerProgress run")
      if (e.lengthComputable) {
        var uploading_progress = Math.round(e.loaded * 100 / e.total);
				console.log(uploading_progress);
        $('.' + f.id).find('.progress')
          .css({'width': uploading_progress + '%'});
      } else {
        console.log('uncomputable');
      }
    },
    onServerLoadAbort: function(e, f) {
      console.log('uploading aborted!')
      $('.' + f.id).find('.progress')
        .css({'background': 'red'}).stop(true);
    },
    onSuccess: function(e, f, res) {
      var media_file_id = $.string(res).evalJSON().media_file.id;
      $('.' + f.id).find('.progress')
        .css({'background': 'green', 'width': '100%'});

      var form = $('.hidden form').clone().attr({
        action: '/media_files/' + media_file_id,
        class: 'edit_media_file',
        id: 'edit_media_file_' + media_file_id,
        'data-remote': 'true'
      });
      form.find('div')
        .append('<input name="_method" type="hidden" value="put" />');

      $('.' + f.id).find('.status').show().append(form);

      form.parent().on('ajax:error', function() {
        $(this).css({'background':'red'});
      }).on('ajax:success', function() {
        $(this).css({'background':'green'});
      });
    },
    onServerError: function(e, f) {
      console.log("fail", f.name);
      $('.' + f.id).find('.progress')
        .css({'background': 'red'}).stop(true);
    }
  });
});
