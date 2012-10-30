class HomeworkAssignsController < ApplicationController
  before_filter :login_required, :pre_load

  def show
    unless (current_user.is_teacher? || current_user.id == params[:id].to_i)
      return redirect_to '/'
    end

    @homework = @assign.homework
    @student_user = @assign.user
  end

  def download_student_zip
    send_file @homework.build_student_uploads_zip(@assign)
  end

  def set_finished
    @homework.set_finished_by!(@assign.user)
    render :text => 'set finished!'
  end

  def set_submitted
    @homework.set_submitted_by!(current_user, params[:content])
    render :text => 'set submitted!'
  end

protected

  def pre_load
    if params[:id]
      @assign = HomeworkAssign.find(params[:id])
      @homework = @assign.homework
    end

  end

end
