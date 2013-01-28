class CoursewaresController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @chapter = Chapter.find params[:chapter_id] if params[:chapter_id]
    @course_ware = CourseWare.find params[:id] if params[:id]
  end

  def create
    @course_ware = @chapter.course_wares.build(:creator => current_user)
    if @course_ware.save
      render :text => 200
    end

    error = @course_ware.errors.first[1]
    render :text => error, :status => 422
  end
end