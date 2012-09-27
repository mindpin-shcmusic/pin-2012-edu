class TeachingPlan < ActiveRecord::Base

  validates :title, :presence => true

  has_many :teaching_plan_courses, :dependent => :destroy 
  has_many :courses, :through => :teaching_plan_courses

  has_many :teams

  accepts_nested_attributes_for :teaching_plan_courses


  include ModelRemovable

  after_false_remove :remove_teaching_plan_courses
  def remove_teaching_plan_courses
    self.teaching_plan_courses.clear
  end
end
