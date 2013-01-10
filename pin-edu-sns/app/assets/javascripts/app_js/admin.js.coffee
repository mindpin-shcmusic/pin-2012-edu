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
      jQuery(this).confirm_dialog '确定要删除吗', =>
        jQuery.ajax
          url: url
          type: 'DELETE'
          success: (res)=>
            $model.fadeOut 200, ->
              $model.remove()

  jQuery(document).delegate '.page-admin-categories .category .ops a.remove', 'click', ->
    url = jQuery(this).data('url')
    $category = jQuery(this).closest('.category')

    if url
      jQuery(this).confirm_dialog '确定要删除吗', =>
        jQuery.ajax
          url: url
          type: 'DELETE'
          success: (res)=>
            $category.fadeOut 200, ->
              $category.remove()

# 构建form中的 select 控件
pie.load ->
  jQuery('.page-model-form .field select').select2()
  jQuery('select.team-selector').select2()


# 展开课程教师信息
pie.load ->
  jQuery(document).delegate '.page-admin-models.courses .model.course .ops .open-teachers', 'click', ->
    $course = jQuery(this).closest('.course')
    $course.toggleClass('open')