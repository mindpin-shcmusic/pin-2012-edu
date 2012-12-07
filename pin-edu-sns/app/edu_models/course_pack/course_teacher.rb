class CourseTeacher < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  validates :course_id, :presence => true
  validates :teacher_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value]}

  after_destroy :remove_relative_course_student_assigns
  def remove_relative_course_student_assigns
    course_student_assigns.each do |assign|
      assign.destroy
    end
  end

  def semester=(semester)
    @semester = semester
    self.semester_value = semester.value
  end

  def semester
    @semester || (
      if !self.semester_value.blank?
        Semester.get_by_value(self.semester_value)
      end
    )
  end

  # 格式
  # [
  #   {:weekday => weekday, :number => [hour,hour2]},
  #   {:weekday => weekday, :number => [hour]}
  # ]
  def time_expression_array
    JSON.parse(self.time_expression || "[]")
  end

  def time_expression_array=(time_expression_array)
    self.time_expression = time_expression_array.to_json
  end

  #{
  # :weekday1 => numbers,
  # :weekday2 => numbers
  # }
  def time_expression_hash
    value = {}
    self.time_expression_array.each do |item|
      value[item["weekday"]] = item["number"]
    end
    value
  end

  def course_student_assigns
    CourseStudentAssign.where(
      :course_id => self.course_id,
      :teacher_user_id => self.teacher_user_id,
      :semester_value => self.semester_value
    )
  end

  def student_users
    User.joins('inner join course_student_assigns as csa on csa.student_user_id = users.id').
      where("csa.course_id = #{self.course_id} and csa.teacher_user_id = #{self.teacher_user_id} and csa.semester_value = '#{self.semester_value}'")
  end

  def set_students(users)
    students = self.course.get_students(:semester=>self.semester,:teacher_user=>self.teacher_user)

    remove_users = students - users
    self.course_student_assigns.each do |assign|
      assign.destroy if remove_users.include?(assign.student_user)
    end

    add_users = users - students
    add_users.each do |user|
      user.add_course(
        :semester => self.semester,
        :course => self.course,
        :teacher_user => self.teacher_user
      )
    end
  end

  def self.get_by_params(course, semester, teacher_user)
    self.where(
      :course_id => course.id,
      :semester_value => semester.value,
      :teacher_user_id => teacher_user.id
    ).first
  end

  def self.get_all_by_semester(semester)
    self.where(
      :semester_value => semester.value
    )
  end

  def get_next_course_time_expressions(current_cte)
    course_time_expressions = []

    self.time_expression_array.each do |expression|

      expression['number'].each do |number|
        cte = CourseTimeExpression.new(expression['weekday'], [number])
        if cte >= current_cte
          cte.course_teacher = self
          course_time_expressions << cte
        end
      end
      
    end

    course_time_expressions
  end


  def get_week_courses_by_time_expression
    course_time_expressions = []
    self.time_expression_array.each do |expression|
      
      expression['number'].each do |number|
        cte = CourseTimeExpression.new(expression['weekday'], [number])
        cte.course_teacher = self

        course_time_expressions << cte
       end
      
    end

    course_time_expressions
  end


  module UserMethods
    def self.included(base)
      base.has_many :course_teachers, :foreign_key => :teacher_user_id
    end
  end
end
