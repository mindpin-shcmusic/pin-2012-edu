# -*- coding: utf-8 -*-
class Admin::MentorCoursesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @mentor_course  = sort_scope(MentorCourse).find params[:id] if params[:id]
  end

  def index
    @mentor_courses = MentorCourse.paginate(:page => params[:page]).order('id DESC')
  end

  def new
  end

  def create
    @mentor_course = MentorCourse.new(params[:mentor_course])
    if @mentor_course.save
      return redirect_to "/admin/mentor_courses"
    end
    
    error = @mentor_course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/mentor_courses/new"
  end

  def show
  end

  def edit
  end

  def update
    if @mentor_course.update_attributes(params[:mentor_course])
      return redirect_to "/admin/mentor_courses"
    end

    error = @mentor_course.errors.first
    flash[:error] = error[1]
    redirect_to :back
  end

  def destroy
    @mentor_course.destroy
    render :text => 'ok'
  end
end
