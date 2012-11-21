# -*- coding: utf-8 -*-
class CourseScoreListsController < ApplicationController
  before_filter :teacher_only, :only => [:create, :new, :course_candidates]

  def mine
    @score_records = current_user.course_score_records.joins(:course_score_list).where('course_score_lists.semester_value = ?', get_semester.value)
  end

  def index
    score_lists = sort_scope(current_user.course_score_lists).paginated(params[:page])
    return @score_lists = score_lists.with_semester(get_semester) if params[:semester]
    @score_lists = score_lists
  end

  def show
    @score_list = CourseScoreList.find(params[:id])
    return redirect_to '/' if current_user != @score_list.teacher_user
  end

  def update
    score_list = CourseScoreList.find(params[:id])
    score_list.update_attributes(params[:course_score_list])
    score_list.save ? flash[:success] = '成绩单已保存' : flash[:error] = '成绩格式不对'
    redirect_to score_list
  end

  def new
    @semesters = Semester.get_recent_semesters
    @current_semester_courses = current_user.get_teacher_courses(:semester => current_semester)
  end

  def create
    redirect_to current_user.create_score_list(:semester => Semester.get_by_value(params[:semester]),
                                               :course   => Course.find(params[:course_id]),
                                               :title    => params[:title])
  end

  def course_candidates
    @courses = current_user.get_teacher_courses :semester => Semester.get_by_value(params[:semester])
    render :json => @courses
  end

protected

  def teacher_only
    return redirect_to '/' if !current_user.is_teacher?
  end

end
