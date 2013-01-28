# -*- coding: utf-8 -*-
class TeachingPlansController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @teaching_plan  = TeachingPlan.find params[:id] if params[:id]
  end


  def index
    @teaching_plans = TeachingPlan.paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @teaching_plan = TeachingPlan.new

    @courses = current_user.get_teacher_courses :semester => Semester.now
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
    @teaching_plan = TeachingPlan.find params[:id]
  end

  def edit
  end

  def update
    if @teaching_plan.update_attributes(params[:teaching_plan])
      return redirect_to "/teaching_plans"
    end

    error = @teaching_plan.errors.first
    flash[:error] = error[1]
    redirect_to "/teaching_plans"
  end

  def destroy
    @teaching_plan.destroy
    render :text => 'ok'
  end

end
