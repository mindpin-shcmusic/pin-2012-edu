class StudentsController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @student = Student.find(params[:id]) if params[:id]
  end
  
  def index
    @students = Student.all
  end
  
  def new
    @student = Student.new
  end
  
  def create
    @student = Student.new(params[:student])
    if @student.save
      return redirect_to "/students/#{@student.id}"
    end
    error = @student.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/students/new"
  end
  
  def show
  end
end
