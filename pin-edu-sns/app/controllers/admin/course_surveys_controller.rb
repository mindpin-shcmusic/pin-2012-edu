# -*- coding: utf-8 -*-
class Admin::CourseSurveysController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @course_survey  = CourseSurvey.find params[:id] if params[:id]
  end

  def index
    kind = params['kind']
    if kind
      @course_surveys = CourseSurvey.with_kind(kind).paginate(:page => params[:page])
    else
      @course_surveys = CourseSurvey.paginate(:page => params[:page])
    end
  end

  def new
  end

  def create
    @course_survey = CourseSurvey.new(params[:course_survey])
    if @course_survey.save
      return redirect_to "/admin/course_surveys/#{@course_survey.id}"
    end
    
    error = @course_survey.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/course_surveys/new"
  end

  def show
  end

  def destroy
    @course_survey.destroy

    render :text => 'ok'
  end


  def show_courses_by_semester
    semester_value = params[:semester_value]
    semester = Semester.get_by_value(semester_value)
    courses = semester.get_courses.map{|course|{:id => course.id, :name => course.name}}

    render :json => courses
  end

  def show_teachers_by_course
    course_id = params[:course_id]
    course = Course.find(course_id)
    teachers = course.get_teachers.map{|user|{:id => user.id, :name => user.teacher.real_name}}

    render :json => teachers
  end

end