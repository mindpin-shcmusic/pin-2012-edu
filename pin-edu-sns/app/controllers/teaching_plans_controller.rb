# -*- coding: utf-8 -*-
class TeachingPlansController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @teaching_plan  = TeachingPlan.find params[:id] if params[:id]
  end

  def new
    @teaching_plan = TeachingPlan.new
  end

  def create
    @teaching_plan = current_user.teaching_plans.create(params[:teaching_plan])
    if @teaching_plan.save
      return redirect_to "/teaching_plans/#{@teaching_plan.id}"
    end
    
    error = @teaching_plan.errors.first
    flash[:error] = error[1]
    redirect_to "/teaching_plans/new"
  end

  def show
  end

  def edit
  end

  def update
    if @teaching_plan.update_attributes(params[:teaching_plan])
      return redirect_to "/teaching_plans/#{@teaching_plan.id}"
    end

    error = @teaching_plan.errors.first
    flash[:error] = error[1]
    redirect_to "/teaching_plans/#{@teaching_plan.id}/edit"
  end

  def destroy
    if current_user == @teaching_plan.creator
      @teaching_plan.destroy
      render :nothing => true, :status => 200
    end
    
  end

  def preview
    @current_chapter = params[:chapter] && @teaching_plan.chapters.find(params[:chapter]) || @teaching_plan.chapters.first
  end

end
