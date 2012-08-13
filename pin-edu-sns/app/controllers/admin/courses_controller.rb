class Admin::CoursesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @course = Course.find(params[:id]) if params[:id]  
  end
  
  def search
    @result = Course.search params[:q]

    render :partial => 'course_list', :locals => {:courses => @result}, :layout => false
  end

  def index
    @courses = Course.paginated(params[:page])
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      return redirect_to "/admin/courses/#{@course.id}"
    end
    
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/new"
  end

  # for ajax
  def destroy
    @course.remove
    render :text => 'ok'
  end

  def edit
  end

  def update
    if @course.update_attributes params[:course]
      return redirect_to "/admin/courses/#{@course.id}"
    end
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/#{@course.id}/edit"
  end
  
  def show
  end

  def select_students
  end
  
  def set_students
    student_ids = params[:student_ids].split(',')
    @course.student_ids = student_ids
    redirect_to "/admin/courses/#{@course.id}"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Course.import_from_csv(params[:csv_file])
    redirect_to "/admin/courses"
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to "/admin/courses/import_from_csv_page"
  end

  def upload_image_page
  end

  def upload_image
    @course.create_courses_image(params[:file])
    redirect_to "/admin/courses/#{@course.id}/upload_image_page"
  rescue Exception => ex
    flash[:error] = ex.message
    redirect_to "/admin/courses/#{@course.id}/upload_image_page"
  end

  def select_cover_page
  end

  def select_cover
    courses_image = @course.courses_images.find(params[:courses_image_id])
    @course.select_cover(courses_image)
    redirect_to "/admin/courses/#{@course.id}/select_cover_page"
  end
end
