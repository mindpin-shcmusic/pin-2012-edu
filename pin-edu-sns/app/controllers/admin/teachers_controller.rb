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
  
  def search
    @result = Teacher.search params[:q]

    render :partial => 'teacher_list', :locals => {:teachers => @result}, :layout => false
  end

  def new
    @teacher = Teacher.new
  end
  
  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      return redirect_to "/admin/teachers/#{@teacher.id}/set_user"
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
    user = User.new(params[:user])
    if !user.save
      error = user.errors.first
      flash[:error] = "#{error[0]} #{error[1]}"
      return redirect_to "/admin/teachers/#{@teacher.id}/set_user"
    end
    @teacher.user_id = user.id
    @teacher.save
    redirect_to "/admin/teachers/#{@teacher.id}"
  end
end
