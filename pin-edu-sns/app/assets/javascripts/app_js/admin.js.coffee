# pie.load ->
#   $('.page-admin-search form').submit (e)->
#     e.preventDefault()
#     e.stopPropagation()

#     $request = $.ajax
#       url      : $(this).attr 'action'
#       type     : 'GET'
#       dataType : 'html'
#       data     :
#         'q' : $('#q').val()


#     $request.success (data)->
#       $('.page-admin-models').html(data)

# admin -> 删除各个模型
pie.load ->
  jQuery(document).delegate '.page-admin-models .model .ops a.remove', 'click', ->
    url = jQuery(this).data('url')
    $model = jQuery(this).closest('.model')

    if url
      $model.confirm_dialog '确定要删除吗', =>
        jQuery.ajax
          url: url
          type: 'DELETE'
          success: (res)=>
            $model.fadeOut 200, ->
              $model.remove()