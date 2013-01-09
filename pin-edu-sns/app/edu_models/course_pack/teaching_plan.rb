class TeachingPlan < ActiveRecord::Base
  class AddStudentToMultiTeachingPlanError < Exception;end

  validates :title, :presence => true

  has_many :teams

  include ModelRemovable
  include Pacecar

end
