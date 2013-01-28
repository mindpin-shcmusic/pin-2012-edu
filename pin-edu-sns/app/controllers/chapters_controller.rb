class ChaptersController < ApplicationController
  before_filter :login_required
  before_filter :per_load

  def per_load
    @teaching_plan = TeachingPlan.find params[:teaching_plan_id] if params[:teaching_plan_id]
    @chapter = Chapter.find params[:id] if params[:id]
  end

  def create
    @chapter = @teaching_plan.chapters.build(:creator=>current_user)
    if @chapter.save
      return render :partial => 'teaching_plans/parts/chapter', :locals => {:chapter => @chapter}
    end

    error = @chapter.errors.first[1]
    render :text => error, :status => 422
  end

  def destroy
    return render :text => 'ok', :status => 200 if @chapter.destroy
    render :text => 'error', :status => 422
  end

end
