class TeachingPlan < ActiveRecord::Base
  class AddStudentToMultiTeachingPlanError < Exception;end

  validates :title, :presence => true

  has_many :teaching_plan_courses, :dependent => :destroy 
  has_many :courses, :through => :teaching_plan_courses

  has_many :teaching_plan_students, :dependent => :destroy
  has_many :students, :through => :teaching_plan_students, :source => :student_user

  has_many :teams

  accepts_nested_attributes_for :teaching_plan_courses


  include ModelRemovable
  include Pacecar

  after_false_remove :remove_teaching_plan_courses
  def remove_teaching_plan_courses
    self.teaching_plan_courses.clear
  end

  def add_course(course)
    teaching_plan_course = self.teaching_plan_courses.find_by_course_id(course.id)
    return if !teaching_plan_course.blank?
    TeachingPlanCourse.create(
      :course => course,
      :teaching_plan => self
    )
  end

  def remove_course(course)
    teaching_plan_course = self.teaching_plan_courses.find_by_course_id(course.id)
    return if teaching_plan_course.blank?
    teaching_plan_course.destroy
  end

  def add_student(student_user)
    teaching_plan_student = TeachingPlanStudent.find_by_student_user_id(student_user.id)
    raise AddStudentToMultiTeachingPlanError.new if !teaching_plan_student.blank?
    TeachingPlanStudent.create(
      :teaching_plan => self,
      :student_user => student_user
    )
  end

  def remove_student(student_user)
    teaching_plan_student = self.teaching_plan_students.find_by_student_user_id(student_user.id)
    return if teaching_plan_student.blank?
    teaching_plan_student.destroy
  end
end
