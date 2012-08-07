pie.load ->
  jQuery('.students-selector, .courses-selector').chosen()
  jQuery('.add-student-attachement-field').click ->
    attachement_field = "<input type='text' size='30' name='homework[homework_student_upload_requirements_attributes][][title]'>"
    del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
    $('#student-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")


    # 删除表单
  jQuery('a.delete').live 'click', ->
    $(this).parent().remove()

    
    # 添加老师附件表单
  jQuery('#add-teacher-attachement-field').click ->
    attachement_field = '<input type="file" name="homework_teacher_attachement[attachement]" multiple="" class="multiple">'
    del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
    $('#teacher-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")



#   jQuery(document).ready ->
#     $('#homework_deadline').datepicker
#         showSecond: true
#         changeMonth: true
#         changeYear: true
#         timeFormat: 'hh:mm:ss'
#         dateFormat: 'yy-mm-dd'
#     # $('#homework_deadline').datepicker('option', $.datepicker.regional['zh-CN'])

#     # 上传老师附件
#     jQuery('.multiple').live 'click', ->
#       jQuery("#dropbox, .multiple").html5Uploader
#         name: "homework_teacher_attachement[attachement]"
#         postUrl: '/homeworks/create_teacher_attachement'
#         onSuccess: (e, file, data)->
#           # console.log(data)
#            attachements = '<input type="text" name="teacher_attachements[]" value="' + data + '" value="">'
#           $('#teacher-attachements').append(attachements)


#     # 添加学生附件表单
#     jQuery('#add-student-attachement-field').click ->
#        attachement_field = "<input type='text' size='30' name='homework[homework_student_upload_requirements_attributes][][title]'>"
#        del_field = "<a href='javascript:void(0)' class='delete'>x</a>"
#        $('#student-attachement-fields').append("<p>" + attachement_field + del_field + "</p>")


#     # 删除表单
#     jQuery('a.delete').live 'click', ->
#       $(this).parent().remove()



#     # 班级列表
#     jQuery('#team-by').click ->
#       # 显示班级列表
#       $('#team-list').show()

#       # 隐藏学生列表
#       $('#student-list').hide()


#     # 确定选择的班级列表
#     jQuery('#confirm-teams').click ->
#       $('#student-block').hide()
#       selected = new Array()
#       $('#team-list input:checked').each(function() {

#            value = $(this).attr('value')
#            name = $(this).attr('name')

#           if($("#del-a-team" + value).length == 0) {
#              delete_name = "<a href='javascript:' onclick='del_team(" + value + ")'>x</a>"
#              input_string = "<span id='del-a-team" + value + "'>" + name + delete_name + 
#                                "<input type='hidden' value='" + value + "' name='teams[]' /></span>"
#             $('#selected-teams').append(input_string)
#           }

#           # 用于临时存放，如果删除班级标签时，可以随时拿出来
#           $('#team-temp-list').append('<div>' + $("#team-current-" + value).html() + '</div>')

#           $('#team-current-' + value).remove()
#       })

#     })


#     # 学生列表
#     jQuery('#student-by').click(function(){
#       # 隐藏班级列表
#       $('#team-list').hide()

#       # 显示学生列表
#       $('#student-list').show()

#     })


#     # 主要用于重新显示学生列表
#     jQuery('#show-students').click(function(){
#       # 先隐藏班级
#       $('#team-list').hide()

#       # 整个学生块先显示出来
#       $('#student-block').show()

#       # 学生列表显示出来
#       $('#student-list').show()

#       # 把分类显示出来
#       $('#category-by').show()

#     })

#     # 确定选择的学生列表
#     jQuery('#confirm-students').click(function(){
#       $('#student-block').hide()
#        selected = new Array()
#       $('#student-list input:checked').each(function() {
#           # selected.push($(this).attr('value'))

#            value = $(this).attr('value')
#            name = $(this).attr('name')

#           if($("#del-a-student" + value).length == 0) {
#              delete_name = "<a href='javascript:' onclick='del_student(" + value + ")'>x</a>"
#              input_string = "<span id='del-a-student" + value + "'>" + name + delete_name + "<input type='hidden' value='" + value + "' name='homework[homework_assigns_attributes][][student_id]' /></span>"
#             $('#selected-students').append(input_string)
#           }

#           # 用于临时存放，如果删除学生标签时，可以随时拿出来
#           $('#student-temp-list').append('<div>' + $("#student-current-" + value).html() + '</div>')

#           $('#student-current-' + value).remove()
