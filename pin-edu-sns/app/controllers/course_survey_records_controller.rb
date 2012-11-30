# -*- coding: utf-8 -*-
class CourseSurveyRecordsController < ApplicationController
  before_filter :login_required
  before_filter :pre_load


  def pre_load
    @kind = params[:kind] if params[:kind]
    case @kind
    when '1'
      @course_survey_record  = CourseSurveyRecord.find(params[:id]) if params[:id]
      @course_survey_record_row = 'course_survey_record'
    when '2'
      @course_survey_record  = CourseSurveyEsRecord.find(params[:id]) if params[:id]
      @course_survey_record_row = 'course_survey_es_record'
    end
    
    @course_survey  = CourseSurvey.find(params[:course_survey_id]) if params[:course_survey_id]
  end

  def index
    if @kind
      @course_surveys = CourseSurvey.with_kind(@kind).paginate(:page => params[:page])
    else
      @course_surveys = CourseSurvey.paginate(:page => params[:page])
    end
  end

  def new
  end

  def create
    case @kind
    when '1'
      @course_survey_record = current_user.course_survey_records.build(params[:course_survey_record])
    when '2'
      @course_survey_record = current_user.course_survey_es_records.build(params[:course_survey_es_record]) 
    end

    
    @course_survey_record.course_survey = @course_survey
    if @course_survey_record.save
      return redirect_to "/course_surveys"
    end
    
    flash_error @course_survey_record
    redirect_to "/course_surveys/#{@course_survey.id}/course_survey_records/new?kind=#{@kind}"
  end

  def edit
  end

  def update
    if @course_survey_record.update_attributes(params[@course_survey_record_row])
      return redirect_to :back
    end

    flash_error @course_survey_record
    redirect_to "/course_survey_records/#{@course_survey_record.id}/edit"
  end

end
