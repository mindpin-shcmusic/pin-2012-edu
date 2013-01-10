# -*- coding: utf-8 -*-
class Admin::TeachingPlansController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @teaching_plan  = TeachingPlan.find params[:id] if params[:id]
  end


  def index
    @teaching_plans = sort_scope(TeachingPlan).with_semester(params[:semester]).
      paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @teaching_plan = TeachingPlan.new
  end

  def create
    @teaching_plan = TeachingPlan.new(params[:teaching_plan])
    if @teaching_plan.save
      return redirect_to "/admin/teaching_plans/#{@teaching_plan.id}"
    end
    
    error = @teaching_plan.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/teaching_plans/new"
  end

  def show
  end

  def edit
  end

  def update
    if @teaching_plan.update_attributes params[:teaching_plan]
      return redirect_to "/admin/teaching_plans/#{@teaching_plan.id}"
    end
    error = @teaching_plan.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/teaching_plans/#{@teaching_plan.id}/edit"
  end

  def destroy
    @teaching_plan.remove
    render :text => 'ok'
  end

  def import_from_csv_page
  end

end
