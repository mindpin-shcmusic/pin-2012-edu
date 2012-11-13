# -*- coding: utf-8 -*-
class Admin::CoursesController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load

  def per_load
    @course = Course.find(params[:id]) if params[:id]  
  end
  
  def index
    @courses = sort_scope(Course).paginated(params[:page])
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      return redirect_to "/admin/courses/#{@course.id}"
    end
    
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/new"
  end

  # for ajax
  def destroy
    @course.remove
    render :text => 'ok'
  end

  def edit
  end

  def update
    if @course.update_attributes params[:course]
      return redirect_to "/admin/courses/#{@course.id}"
    end
    error = @course.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/courses/#{@course.id}/edit"
  end
  
  def show
    @current_tab = (params[:tab] || :basic).to_sym
  end

  def select_students
  end
  
  def set_students
    student_user_ids = params[:student_user_ids].split(',')
    @course.student_user_ids = student_user_ids
    redirect_to "/admin/courses/#{@course.id}"
  end

  def import_from_csv_page
  end

  def import_from_csv
    Course.import_from_csv(params[:csv_file])
    redirect_to "/admin/courses"
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to "/admin/courses/import_from_csv_page"
  end

  def select_cover_page
  end

  def select_cover
    course_resource = @course.course_resources.find(params[:course_resource_id])
    @course.cover = course_resource
    @course.save
    redirect_to "/admin/courses/#{@course.id}"
  end

  def add_teacher_page
  end

  def add_teacher
    users = params[:user_ids].map{|id|User.find(id)}
    semester = Semester.now
    users.each do |user|
      @course.add_teacher(
        :semester => semester,
        :teacher_user => user
      )
    end
    redirect_to "/admin/courses/#{@course.id}"
  end
end
