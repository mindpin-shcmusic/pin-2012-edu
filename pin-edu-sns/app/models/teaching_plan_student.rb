class TeachingPlanStudent < ActiveRecord::Base
  validates :teaching_plan_id, :presence => true
  validates :student_user_id, :presence => true,
      :uniqueness => true

  belongs_to :teaching_plan
  belongs_to :student_user, :class_name => 'User', :foreign_key => :student_user_id
end
