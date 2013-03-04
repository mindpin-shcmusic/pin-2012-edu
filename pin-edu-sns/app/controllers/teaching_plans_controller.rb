# -*- coding: utf-8 -*-
class TeachingPlansController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  before_filter :restrict_access, :except => [:new, :create]
  before_filter :teacher_only, :only => [:new, :create]

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
    if current_user.is_student?
      return redirect_to "/teaching_plans/#{@teaching_plan.id}/preview" 
    end
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
    if current_user.teaching_plans.find_by_id(params[:id]).destroy
      render :nothing => true, :status => 200
    end
  end

  def preview
    @current_chapter = params[:chapter] && @teaching_plan.chapters.find(params[:chapter]) || @teaching_plan.chapters.first
  end

protected

  def restrict_access
    redirect_to root_path if !current_user.can_access_teaching_plan?(@teaching_plan)
  end

  def teacher_only
    redirect_to root_path if !current_user.is_teacher?
  end

end
