# -*- coding: utf-8 -*-
class CourseSurveysController < ApplicationController
  before_filter :login_required
  before_filter :pre_load

  def pre_load
    @course_survey  = CourseSurvey.find params[:id] if params[:id]
  end

  def index
    surveys = CourseSurvey.with_user(current_user)

    @course_surveys = filter surveys do
      send('0') {:default}
      send('1') {surveys.with_kind('1')}
      send('2') {surveys.with_kind('2')}
    end
  end

  def show
  end

end
