class Admin::TeamsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @team = Team.find(params[:id]) if params[:id]
  end
  
  def index
    @teams = Team.paginated(params[:page])
  end
  
  def search
    @result = Team.search params[:q]

    render :partial => 'team_list', :locals => {:teams => @result}, :layout => false
  end

  def new
    @team = Team.new
  end
  
  def create
    @team = Team.new(params[:team])
    if @team.save
      return redirect_to "/admin/teams/#{@team.id}"
    end
    
    error = @team.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/admin/teams/new"
  end
  
  def destroy
    @team.remove
    redirect_to :action => :index
  end
  
  def show
  end
  
  def select_teacher
  end
  
  def set_teacher
    @team.teacher = Teacher.find(params[:team][:teacher_id])
    @team.save
    redirect_to "/admin/teams/#{@team.id}"
  end
  
  def select_students
  end
  
  def set_students
    student_ids = params[:student_ids]||[]
    @team.student_ids = student_ids
    redirect_to "/admin/teams/#{@team.id}"
  end
end
