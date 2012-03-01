class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @course = Course.find(params[:id]) if params[:id]  
  end
  
  def index
    @courses = Course.all
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      return redirect_to "/courses/#{@course.id}"
    end
    
    error = @course.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/courses/new"
  end
  
  def show
  end
  
  def select_teacher
  end
  
  def set_teacher
    @course.teacher = Teacher.find(params[:course][:teacher_id])
    @course.save
    redirect_to "/courses/#{@course.id}"
  end
end
