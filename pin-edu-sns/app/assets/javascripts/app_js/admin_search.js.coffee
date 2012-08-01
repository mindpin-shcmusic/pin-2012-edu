pie.load ->
  $('.page-admin-search form').submit (e)->
    e.preventDefault()
    e.stopPropagation()

    $request = $.ajax
      url      : $(this).attr 'action'
      type     : 'GET'
      dataType : 'html'
      data     :
        'q' : $('#q').val()


    $request.success (data)->
      $('.page-admin-models').html(data)