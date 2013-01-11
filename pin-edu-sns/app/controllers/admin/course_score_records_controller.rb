class Admin::CourseScoreRecordsController < ApplicationController
  layout 'admin'
  before_filter :login_required
  before_filter :per_load
  def per_load
    @course_score_record = CourseScoreRecord.find(params[:id]) if params[:id]
  end

  def index
    @course_score_records = sort_scope(CourseScoreRecord).paginated(params[:page])
  end

  def new
    @course_score_record = CourseScoreRecord.new
  end

  def create
    @course_score_record = CourseScoreRecord.new(params[:course_score_record])
    @course_score_record.creator = current_user
    if @course_score_record.save
      return redirect_to "/admin/course_score_records"
    end

    error = @course_score_record.errors.first
    flash[:error] = error[1]
    redirect_to "/admin/course_score_records/new"
  end

  def edit
  end

  def update
    @course_score_record.update_attributes(params[:course_score_record])
    return redirect_to "/admin/course_score_records"
  end

  def get_students_by_course
    @course = Course.find(params[:course_id])

    student_users = @course.get_students
    render :json => student_users.map{|user| {:id=>user.id,:name=>user.real_name}}
  end
end