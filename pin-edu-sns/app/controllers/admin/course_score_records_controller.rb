class Admin::CourseScoreRecordsController < ApplicationController
  layout 'admin'
  before_filter :login_required

  def index
    @course_score_records = sort_scope(CourseScoreRecord).paginated(params[:page])
  end

  def new
  end
end