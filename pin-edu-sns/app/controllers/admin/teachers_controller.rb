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
    @teacher.build_user
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
  
  # for ajax
  def destroy
    @teacher.remove
    render :text => 'ok'
  end

  def show
  end

end
