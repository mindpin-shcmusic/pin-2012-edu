class TeachingPlan < ActiveRecord::Base

  validates :title, :presence => true

  has_many :teaching_plan_courses
  has_many :courses, :through => :teaching_plan_courses

  has_many :teams

  include ModelRemovable
end
