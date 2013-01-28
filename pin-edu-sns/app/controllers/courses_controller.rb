# -*- coding: utf-8 -*-
class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :per_load

  def per_load
    @course  = Course.find params[:id] if params[:id]
  end

  def index
    return render "demo_teaching_plan_#{params[:demo]}" if params[:demo]

    case params[:tab]
    when 'mine'
      _index_mine
    else
      _index_all
    end

  end

  def show
    @current_tab = (params[:tab] || :basic).to_sym

    @teaching_plans = TeachingPlan.with_course_teacher(current_user, Semester.now, @course)
  end

  def curriculum
    @course_time_expression_collection_map = current_user.course_time_expression_collection_map
  end

  def curriculum_demo
    @demo_data = [
      ["Java 语言","Java 语言","数据结构","数据结构",nil,nil,"计算机操作系统","计算机操作系统",nil,nil,"计算机图形学",nil],
      ["编译原理","编译原理",nil,"Java 语言","Java 语言",nil,nil,"数据结构","数据结构",nil,nil,nil],
      ["计算机图形学","计算机图形学",nil,nil,nil,nil,nil,"计算机操作系统","计算机操作系统",nil,"数据结构",nil],
      ["编译原理","编译原理",nil,nil,nil,nil,"Android 开发","Android 开发",nil,nil,nil,nil],
      ["计算机操作系统",nil,nil,nil,nil,nil,nil,nil,"计算机图形学","计算机图形学","编译原理",nil],
      [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
      [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
    ]
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
