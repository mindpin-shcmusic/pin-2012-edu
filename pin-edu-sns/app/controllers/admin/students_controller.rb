class Admin::StudentsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @student = Student.find(params[:id]) if params[:id]
  end
  
  def index
    @students = Student.paginated(params[:page])
  end
  
  def new
    @student = Student.new
    @student.build_user
  end
  
  def search
    @result = Student.search params[:q]

    render :partial => 'student_list', :locals => {:students => @result}, :layout => false
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      return redirect_to "/admin/students/#{@student.id}"
    end
    error = @student.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/admin/students/new"
  end
  
  def destroy
    @student.remove
    redirect_to :action => :index
  end
  
  def show
  end
end
