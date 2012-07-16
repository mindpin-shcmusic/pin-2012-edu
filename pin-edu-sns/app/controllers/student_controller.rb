class StudentController < ApplicationController
  def index
    if params[:status] == 'deadline'
      @homeworks = current_user.student.deadline_student_homeworks
    elsif params[:status] == 'undeadline'
      @homeworks = current_user.student.undeadline_student_homeworks
    else
      @homeworks = current_user.student.homeworks
    end
    
  end

  def show
    @homework = Homework.find(params[:id])
    @student_assign = current_user.student.homework_assigns.find_by_homework_id(params[:id])
    @homework_assign = HomeworkAssign.new
  end

  def create
    homework_id = params[:homework_assign][:homework_id]
    content = params[:homework_assign][:content]
    homework = Homework.find(homework_id)
    return redirect_to :back if homework.submit_by_student(current_user, content)

    error = @homework_assign.errors.first
    flash.now[:error] = "#{error[0]} #{error[1]}"
    render :action => :show
  end
  
  # 学生上传作业附件
  def upload_homework_attachement
    # attachement_id 值由页面ajax url 参数传进来
    params[:homework_student_upload][:attachement_id] = params[:attachement_id]
    params[:homework_student_upload][:creator_id] = current_user.id
    @homework_student_upload = HomeworkStudentUpload.create( params[:homework_student_upload] )

    # 当前作业ID, 用于生成 zip 文件名
    homework_id = @homework_student_upload.homework_student_upload_requirement.homework.id
    homework = Homework.find(homework_id)
    homework.build_student_attachements_zip(current_user, @homework_student_upload)
    
    render :nothing => true
  end
  
  # 学生重新上传作业附件
  def upload_homework_attachement_again
    homework_student_upload_requirement = HomeworkStudentUploadRequirement.find(params[:attachement_id])
    @homework_student_upload = homework_student_upload_requirement.upload_of_user(current_user)
    old_file = @homework_student_upload.attachement_file_name;
    @homework_student_upload.attachement = params[:homework_student_upload][:attachement]
    @homework_student_upload.save
    
    # 当前作业ID, 用于生成 zip 文件名
    homework_id = @homework_student_upload.homework_student_upload_requirement.homework.id
    homework = Homework.find(homework_id)
    homework.build_student_attachements_zip(current_user, @homework_student_upload, old_file)
    
    render :nothing => true
  end

end
