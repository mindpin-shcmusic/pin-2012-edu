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

  # 从现在时间开始，本周内上的课程，包括当前正在进行的课程
  def next_for_student
    @next_course_teachers = []
    

    current_cte = CourseTimeExpression.get_by_time(Time.now)

    student_courses = current_user.get_student_course_teachers(:semester => Semester.now)
    student_courses.each do |course_teacher|
      time_expression = JSON.parse(course_teacher.time_expression)
      time_expression.each do |expression|
        
        expression['number'].each do |number|
          cte = CourseTimeExpression.new(expression['weekday'], [number])
          if cte >= current_cte
            class_detail = Hash.new(0)

            class_detail[:weekday] = cte.weekday
            class_detail[:weekday_str] = cte.weekday_str
            class_detail[:class_time] = "#{cte.start_time_str} - #{cte.end_time_str}"
            class_detail[:course_teacher] = course_teacher

            @next_course_teachers << class_detail
          end
        end
        
      end
 
    end


    @next_course_teachers = @next_course_teachers.sort_by {|class_detail| class_detail[:weekday]}
    @next_course_teachers = @next_course_teachers.group_by{|item| item[:weekday]}

  end

end
