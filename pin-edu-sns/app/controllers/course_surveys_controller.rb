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
      @course_surveys = CourseSurvey.with_kind(kind).paginate(:page => params[:page])
    else
      @course_surveys = CourseSurvey.paginate(:page => params[:page])
    end
  end

end
