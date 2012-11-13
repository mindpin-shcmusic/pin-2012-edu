# -*- coding: utf-8 -*-
class CourseSurveysController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @course_survey  = CourseSurvey.find params[:id] if params[:id]
  end

  def index
    kind = params[:kind]

    if kind
      course_surveys = CourseSurvey.with_kind(kind).with_student(current_user) if current_user.is_student?
      course_surveys = CourseSurvey.with_kind(kind).with_teacher(current_user) if current_user.is_teacher?
    else
      course_surveys = CourseSurvey.with_student(current_user) if current_user.is_student?
      course_surveys = CourseSurvey.with_teacher(current_user) if current_user.is_teacher?
    end

    @course_surveys = sort_scope(course_surveys).paginated(params[:page])
  end


  def show
  end

end
