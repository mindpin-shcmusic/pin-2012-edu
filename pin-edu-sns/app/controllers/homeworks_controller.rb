# encoding: utf-8
class HomeworksController < ApplicationController
  before_filter :login_required
  before_filter :pre_load_teacher, :only => [:create, :new, :destroy]

  def pre_load_teacher
    return redirect_to '/' unless current_user.is_teacher?
  end
  
  def create
    course = Chapter.find(params[:homework][:chapter_id]).teaching_plan.course
    new_homework = current_user.teacher_homeworks.build(params[:homework])
    create_resource new_homework,
                    :success_url => "/courses/#{course.id}/nav_homeworks" do |homework|

      if params[:file_entities]
        params[:file_entities].each do |file|
          attach = HomeworkTeacherAttachment.create(:creator        => current_user,
                                                    :name           => file[:name],
                                                    :file_entity_id => file[:id],
                                                    :homework       => homework)
        end
      end

    end
  end
  
  def create_student_upload
    requirement = HomeworkRequirement.find(params[:requirement_id])
    upload = HomeworkStudentUpload.find_or_initialize_by_creator_id_and_requirement_id(current_user.id, requirement.id)
    upload.file_entity_id = params[:file_entity_id]
    upload.name = params[:name]
    upload.homework = requirement.homework
    upload.save

    all_completed = requirement.homework.all_requirements_uploaded_by?(current_user)
    render :json => {:all_completed=>all_completed}
  end

  def new
    return redirect_to root_path if !params[:chapter_id]
    @chapter = Chapter.find(params[:chapter_id])
    @homework = Homework.new
    @teacher_attachments = []
    @requirements = []
  end

  def index
    homeworks = params[:chapter_id] ? current_user.homeworks.where(:chapter_id => params[:chapter_id]) : current_user.homeworks
    @homeworks = filter homeworks do
      expired   {current_user.expired_homeworks}
      unexpired {current_user.unexpired_homeworks}
    end
  end
  
  def show
    @homework = Homework.find(params[:id])
  end


  # def edit
  #   @homework = Homework.find(params[:id])
  #   @homework_student_upload_requirements = HomeworkRequirement.where(:homework_id => @homework.id)
  #   @teacher_attachments = HomeworkTeacherAttachment.where(:homework_id => @homework.id)

  #   @courses = Course.where(:teacher_user_id => current_user.id)
  #   @teams = Team.where(:teacher_user_id => current_user.id)

  #   @selected_teams = @homework.homework_assign_rule.expression[:teams].map(&:to_i)
  #   @requirements = HomeworkRequirement.where(:homework_id => @homework.id)
  # end

  # def update
  #   @homework = Homework.find(params[:id])
  #   @homework.update_attributes(params[:homework])
  #   if @homework.save
  #     @homework.assign_to_expression({:teams => params[:teams]}.to_json)
      
  #     if params[:teacher_attachment_ids]
  #       params[:teacher_attachment_ids].each do |id|
  #         attach = HomeworkTeacherAttachment.find(id)
  #         attach.homework = @homework
  #         attach.save
  #       end
  #     end

  #     return redirect_to @homework
  #   end
    
  #   error = @homework.errors.first
  #   flash.now[:error] = "#{error[0]} #{error[1]}"
  #   redirect_to '/homeworks/new'
  #   return redirect_to @homework if @homework.save
  #   redirect_to :back
  # end

  def download_teacher_zip
    homework = Homework.find(params[:id])
    
    send_file homework.build_teacher_attachments_zip
  end

  def destroy_teacher_attachment
    HomeworkTeacherAttachment.find(params[:id]).destroy
    render :text => 'attachment destroyed!'
  end

  def destroy_requirement
    HomeworkRequirement.find(params[:id]).destroy
    render :text => 'requirement destroyed!'
  end

  def destroy
    homework = Homework.find(params[:id])
    redirect_to root_path if current_user != homework.creator
    render :text => homework.destroy ? "/courses/#{homework.course.id}/nav_homeworks" : homework_path(homework)
  end
end
