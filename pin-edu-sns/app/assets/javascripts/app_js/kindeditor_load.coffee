try
  KindEditor.ready (K) ->
    editor = K.create '.KindEditor',
      uploadJson : "/kindeditor_upload"
    jQuery(document).on 'form-ready-submit', ->
      try
        editor.sync()
      catch e
catch e
