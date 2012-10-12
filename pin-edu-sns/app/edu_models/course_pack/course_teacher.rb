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

  def self.get_by_params(course, semester, teacher_user)
    self.where(
      :course_id => course.id,
      :semester_value => semester.value,
      :teacher_user_id => teacher_user.id
    ).first
  end

  module UserMethods
    def self.included(base)
      base.has_many :course_teachers, :foreign_key => :teacher_user_id
      base.has_many :courses, :through => :course_teachers
    end
  end
end
