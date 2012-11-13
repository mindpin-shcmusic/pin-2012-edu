class Admin::TeamsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @team = Team.find(params[:id]) if params[:id]
  end
  
  def index
    @teams = sort_scope(Team).paginated(params[:page])
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
    flash[:error] = error[1]
    redirect_to "/admin/teams/new"
  end
  
  # for ajax
  def destroy
    @team.remove
    render :text => 'ok'
  end
  
  def show
  end

  def edit
  end

  def update
    if @team.update_attributes params[:team]
      return redirect_to "/admin/teams/#{@team.id}"
    end
    error = @team.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/teams/#{@team.id}/edit"
  end
  
  def select_students
  end
  
  def set_students
    student_user_ids = params[:student_user_ids].split(',')
    @team.student_user_ids = student_user_ids
    redirect_to "/admin/teams/#{@team.id}"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Team.import_from_csv(params[:csv_file])
    redirect_to "/admin/teams"
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to "/admin/teams/import_from_csv_page"
  end
end
