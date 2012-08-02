class CoursesController < ApplicationController
  before_filter :per_load
  def per_load
    @course  = Course.find params[:id] if params[:id]
  end


  def index
    @courses = Course.all
  end

  def show
  end

  def upload_image_page
    @course.file_entities.build
  end

  def upload_image
    @course.create_courses_image(params[:file])
    redirect_to "/courses/#{@course.id}/upload_image_page"
  rescue Exception => ex
    flash[:error] = ex.message
    redirect_to "/courses/#{@course.id}/upload_image_page"
  end

  def select_cover_page
  end

  def select_cover
    courses_image = @course.courses_images.find(params[:courses_image_id])
    @course.select_cover(courses_image)
    redirect_to "/courses/#{@course.id}/select_cover_page"
  end
end
