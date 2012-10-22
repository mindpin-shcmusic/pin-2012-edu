class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :per_load
  def per_load
    @course  = Course.find params[:id] if params[:id]
  end


  def index
    @courses = Course.paginated(params[:page])
  end

  def mine
    @courses = current_user.courses.paginated(params[:page])
    render :index
  end

  def show
    @current_tab = (params[:tab] || :basic).to_sym
  end

  def for_student
    @student_courses = current_user.get_student_course_teachers(:semester => Semester.now)
  end

  def for_teacher
    @teacher_courses = current_user.get_teacher_course_teachers(:semester => Semester.now)
  end

end
