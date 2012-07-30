class Admin::TeachersController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @teacher = Teacher.find(params[:id]) if params[:id]
  end
  
  def index
    @teachers = Teacher.paginated(params[:page])
  end
  
  def new
    @teacher = Teacher.new
  end
  
  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      return redirect_to "/admin/teachers/#{@teacher.id}"
    end
    error = @teacher.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/admin/teachers/new"
  end
  
  def destroy
    @teacher.remove
    redirect_to :action => :index
  end

  def show
  end

  def set_user
  end

  def do_set_user
    @teacher.user_id = params[:teacher][:user_id]
    @teacher.save
    redirect_to "/teachers/#{@teacher.id}"
  end
end
