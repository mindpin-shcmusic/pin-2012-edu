# -*- coding: gb2312 -*-
class HomeworksController < ApplicationController
  before_filter :pre_load_teacher, :except => [:show, :index, :student, :create_student_upload]
  before_filter :login_required

  def pre_load_teacher
    return redirect_to '/' unless current_user.is_teacher?
  end
  
  def create
    @homework = current_user.homeworks.build(params[:homework])
    if @homework.save
      teacher_attachements = params[:teacher_attachements]
      unless teacher_attachements.blank?
        teacher_attachements.each do |attachement_id|
          homework_teacher_attachement = HomeworkTeacherAttachement.find(attachement_id)
          homework_teacher_attachement.homework = @homework
          homework_teacher_attachement.creator = current_user
          homework_teacher_attachement.save
        end
      end
      
      # 把家庭作业分配给班级里的学生
      teams = params[:teams]
      unless teams.blank?
        teams.each do |team_id|
          team = Team.find(team_id)
                   
          team.students.each do |student|
            
            # 如果学生没有被分配到作业
            unless @homework.has_assigned(student)
              HomeworkAssign.create(:student => student, :homework => @homework, :creator => current_user) 
            end
            
          end
        end
      end
      
      params[:teacher_attachment_ids].each do |id|
        attach = HomeworkTeacherAttachment.find(id)
        attach.homework = @homework
        attach.save
      end

      return redirect_to @homework
    end
    
    error = @homework.errors.first
    flash.now[:error] = "#{error[0]} #{error[1]}"
    redirect_to '/homeworks/new'
  end
  
  def create_teacher_attachment
    file_entity = SliceTempFile.find(params[:slice_temp_file_id]).build_file_entity
    @homework_teacher_attachment = HomeworkTeacherAttachment.create(:creator => current_user, :name =>params[:file_name], :file_entity => file_entity)
    render :text => @homework_teacher_attachment.id
  end
  
  def create_student_upload
    upload = HomeworkStudentUpload.find_or_initialize_by_creator_id_and_requirement_id(params[:homework_student_upload][:creator_id], params[:homework_student_upload][:requirement_id])
    upload.update_attributes params[:homework_student_upload]
    upload.name = params[:file_name]
    upload.file_entity = upload.file_entity || FileEntity.new
    upload.file_entity.update_attributes :attach => params[:attachment], :merged => true
    upload.save
    render :text => upload.name
  end

  def new
    @homework = Homework.new
    @homework_student_upload_requirement = HomeworkStudentUploadRequirement.new
    
    # 所有课程
    @courses = Course.all
    
    # 班级列表
    @teams = Team.all
    
    # 学生列表
    @students = Student.all
  end

  def index
    if params[:status] == 'deadline'
      @homeworks = current_user.deadline_homeworks
    elsif params[:status] == 'undeadline'
      @homeworks = current_user.undeadline_homeworks
    elsif current_user.is_teacher?
      @homeworks = current_user.homeworks
    elsif current_user.is_student?
      @homeworks = current_user.student_homeworks
    end
  end
  
  
  def show
    @homework = Homework.find(params[:id])
  end
  
  
  # 老师查看具体某一学生作业页面
  def student
    unless (current_user.is_teacher? || current_user.id == params[:user_id].to_i)
      return redirect_to '/'
    end
    @homework = Homework.find(params[:homework_id])
    @student = User.find(params[:user_id])
  end
  
  def download_teacher_zip
    homework = Homework.find(params[:id])
    
    # 生成老师上传的附件压缩包
    homework.build_teacher_attachments_zip(homework.creator)
    
    render :file => "/MINDPIN_MRS_DATA/attachments/homework_attachments/homework_teacher#{homework.creator.id}_#{homework.id}.zip", :content_type => 'application/zip', :status => :ok
  end

end
