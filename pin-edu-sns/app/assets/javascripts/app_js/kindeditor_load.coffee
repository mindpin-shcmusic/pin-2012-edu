try

  items = [
          'source', '|', 'undo', 'redo', '|', 'preview', 'template', 'cut', 'copy', 'paste',
          'plainpaste', 'wordpaste', '|', 'justifyleft', 'justifycenter', 'justifyright',
          'justifyfull', 'insertorderedlist', 'insertunorderedlist', 'indent', 'outdent', 'subscript',
          'superscript', 'clearhtml', 'quickformat', 'selectall', '|', 'fullscreen', '/',
          'formatblock', 'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold',
          'italic', 'underline', 'strikethrough', 'lineheight', 'removeformat', '|', 'image', 'multiimage',
          'media', 'insertfile', 'table', 'hr', 'emoticons',
          'link', 'unlink', '|', 'about'
  ]

  KindEditor.ready (K) ->
    editor = K.create '.KindEditor',

      uploadJson : "/kindeditor_upload"
      items      : items

    jQuery(document).on 'form-ready-submit', ->
      try
        editor.sync()
      catch e
catch e
