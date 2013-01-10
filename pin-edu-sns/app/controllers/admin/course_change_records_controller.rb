class Admin::CourseChangeRecordsController < ApplicationController
  layout 'admin'
  before_filter :pre_load
  def pre_load
    @course_teacher = CourseTeacher.find(params[:course_teacher_id]) if params[:course_teacher_id]
    @course_change_record = CourseChangeRecord.find(params[:id]) if params[:id]
  end

  def new
  end

  def create
    week_expression = params[:course_change_record][:week_expression]
    start_date_str = week_expression.split(",")[0]
    end_date_str = week_expression.split(",")[1]
    start_date = Time.parse(start_date_str)
    end_date = Time.parse(end_date_str)

    time_expression_array = params[:value].map do |index,item|
      item["number"] = item["number"].to_i
      item["weekday"] = item["weekday"].to_i
      item
    end

    @course_change_record = CourseChangeRecord.new(
      :start_date => start_date,
      :end_date => end_date,
      :time_expression_array => time_expression_array,
      :location => @course_teacher.location,
      :teacher_user_id => @course_teacher.teacher_user_id,
      :course_id => @course_teacher.course_id,
      :semester_value => @course_teacher.semester_value
      )

    if @course_change_record.save
      teacher = Teacher.find_by_user_id(@course_teacher.teacher_user_id)
      redirect_to "/admin/teachers/#{teacher.id}"
    else
      error = @course_change_record.errors.first
      flash[:error] = error[1]
      redirect_to "/admin/course_teachers/#{@course_teacher.id}/course_change_records/new"
    end
  end

  def destroy
    @course_change_record.destroy
    teacher = Teacher.find_by_user_id(@course_change_record.teacher_user_id)
    redirect_to "/admin/teachers/#{teacher.id}"
  end

end