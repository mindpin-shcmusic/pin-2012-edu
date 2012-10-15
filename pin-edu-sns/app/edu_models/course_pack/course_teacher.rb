class CourseTeacher < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  validates :course_id, :presence => true
  validates :teacher_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value]}

  def semester=(semester)
    @semester = semester
    self.semester_value = semester.value
  end

  def semester
    @semester
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

  module UserMethods
    def self.included(base)
      base.has_many :course_teachers, :foreign_key => :teacher_user_id
      base.has_many :courses, :through => :course_teachers
    end
  end
end
