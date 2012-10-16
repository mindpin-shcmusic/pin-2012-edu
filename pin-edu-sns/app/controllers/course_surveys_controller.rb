# -*- coding: utf-8 -*-
class CourseSurveysController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @course_survey  = CourseSurvey.find params[:id] if params[:id]
  end

  def index
    kind = params[:kind]
    case kind
    when '1'
      @course_surveys = CourseSurvey.where(:kind => kind).paginate(:page => params[:page])
    when '2'
      @course_surveys = CourseSurvey.where(:kind => kind).paginate(:page => params[:page])
    else
      @course_surveys = CourseSurvey.paginate(:page => params[:page])
    end    
  end

end
