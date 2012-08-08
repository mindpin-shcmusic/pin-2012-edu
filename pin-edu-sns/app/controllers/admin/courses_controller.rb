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
  
  def show
  end
  
  def select_teacher
  end
  
  def set_teacher
    @course.teacher = Teacher.find(params[:course][:teacher_id])
    @course.save
    redirect_to "/admin/courses/#{@course.id}"
  end
end
