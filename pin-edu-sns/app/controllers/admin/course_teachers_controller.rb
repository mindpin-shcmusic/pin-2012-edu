# -*- coding: utf-8 -*-
class Admin::CourseTeachersController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    if params[:id]
      @course_teacher  = CourseTeacher.find params[:id]
    end
  end

  def index
  end

  def new
    @course_teacher = CourseTeacher.new
  end

  def create
    time_expression = CourseTeacherMethods.combine_time_expression(params[:time_expression])

    CourseTeacher.create(
      :course_id => 1,
      :teacher_user_id => 2,
      :location => '11',
      :time_expression => time_expression.to_json
    )

    redirect_to "/admin/course_teachers"
  end

  def destroy
    @course_teacher.destroy
    redirect_to "/admin/courses/#{@course_teacher.course.id}"
  end

  def edit_time_expression
  end

  def update_time_expression
    time_expression = CourseTeacherMethods.combine_time_expression(params[:time_expression])
    @course_teacher.update_attributes(:time_expression => time_expression.to_json)

    redirect_to "/admin/course_teachers"
  end


  def show_time_expression
  end

  def select_students_page
  end

  def select_students
    users = params[:user_ids].map{|id|User.find(id)}
    @course_teacher.set_students(users)
    redirect_to "/admin/courses/#{@course_teacher.course.id}"
  end

end
