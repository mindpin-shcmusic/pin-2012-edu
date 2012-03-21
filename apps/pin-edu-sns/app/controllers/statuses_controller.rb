class StatusesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @team = Team.find(params[:team_id]) if params[:team_id]
    @status = Status.find(params[:id]) if params[:id]
  end
  
  def index
    @statuses = @team.statuses
  end
  
  def create
    @status = Status.new(:content=>params[:content])
    @status.creator = current_user
    @status.teams = [@team]
    if @status.save
      return redirect_to "/teams/#{@team.id}/statuses"
    end
    
    error = @status.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    return redirect_to "/teams/#{@team.id}/statuses"
  end
  
  def repost
  end
  
  def do_repost
    teams = (params[:team_ids]||[]).map{|id|Team.find_by_id(id)}.compact
    @status.do_repost(params[:content],current_user,teams)
    redirect_to "/teams/#{teams.first.id}/statuses"
  rescue Exception=>ex
    flash[:error] = ex.message
    puts ex.backtrace*"\n"
    redirect_to "/statuses/#{@status.id}/repost"
  end
end
