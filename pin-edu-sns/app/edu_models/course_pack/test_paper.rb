class TestPaper < ActiveRecord::Base

  belongs_to :teaching_plan
  belongs_to :student_user

  validates :teaching_plan , :presence => true
  validates :student_user , :presence => true
end