# -*- coding: utf-8 -*-
class Admin::CourseSurveysController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @course_survey  = CourseSurvey.find params[:id] if params[:id]
  end

  def index
    kind = params['tab'] || "0"
    course_surveys = sort_scope(CourseSurvey)
    if kind != "0"
      @course_surveys = course_surveys.with_kind(kind).paginate(:page => params[:page])
    else
      @course_surveys = course_surveys.paginate(:page => params[:page])
    end
  end

  def new
    semester = Semester.get_by_value(Semester.now.value)
    @current_courses = semester.get_courses.map{|course|{:id => course.id, :name => course.name}}
  end

  def create
    @course_survey = CourseSurvey.new(params[:course_survey])
    if @course_survey.save
      return redirect_to "/admin/course_surveys/#{@course_survey.id}"
    end
    
    flash_error @course_survey
    redirect_to "/admin/course_surveys/new"
  end

  def show
  end

  def destroy
    @course_survey.destroy

    render :text => 'ok'
  end


  def show_courses_by_semester
    semester = params[:semester]
    semester = Semester.get_by_value(semester)
    courses = semester.get_courses.map{|course|{:id => course.id, :name => course.name}}

    render :json => courses
  end

  def show_teachers_by_course
    course_id = params[:course_id]
    semester = params[:semester]

    course = Course.find(course_id)
    semester = Semester.get_by_value(semester)

    teachers = course.get_teachers(:semester => semester).map{|user|{:id => user.id, :name => user.real_name}}

    render :json => teachers
  end

end
