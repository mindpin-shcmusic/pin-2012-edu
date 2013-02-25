# -*- coding: utf-8 -*-
class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :per_load

  def per_load
    @course  = Course.find params[:id] if params[:id]
  end

  def index
    case params[:tab]
    when 'mine'
      _index_mine
    else
      _index_all
    end

  end

  def show
    @current_tab = (params[:tab] || :basic).to_sym
    semester = Semester.now

    @teaching_plans = if current_user.is_teacher?
      TeachingPlan.with_course_teacher(current_user, semester, @course)
    elsif current_user.get_student_courses(:semester => semester,
                                           :student_user => current_user).include?(@course)

      teacher_user = CourseStudentAssign.where('course_id = ? and student_user_id = ?', @course.id, current_user.id).first.teacher_user
      TeachingPlan.with_course_teacher(teacher_user, semester, @course)
    else
      []
    end
  end

  def curriculum
    @course_time_expression_collection_map = current_user.course_time_expression_collection_map
  end

  # 从现在时间开始，本周内上的课程，包括当前正在进行的课程
  def next_for_student
    @next_course_teachers = current_user.get_next_course_time_expressions_hash
  end

  def next_for_teacher
    @next_course_teachers = current_user.get_next_course_time_expressions_hash
  end

  def subscribe
    current_user.subscribe_course(@course)
    redirect_to :action => :show
  end

  def subscriptions
    @courses = current_user.subscribed_courses
  end

  private
  def _index_mine
    courses = if current_user.is_teacher?
                current_user.get_teacher_courses(:semester => get_semester)
              else
                current_user.get_student_courses(:semester => get_semester)
              end
    @courses = courses.paginated(params[:page])
  end

  def _index_all
    @courses = sort_scope(Course).paginated(params[:page])
  end
end
