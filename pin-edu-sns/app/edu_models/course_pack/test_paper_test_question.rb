class TestPaperTestQeustion < ActiveRecord::Base
  belongs_to :test_paper
  belongs_to :teaching_plan

  validates :test_paper,
            :teaching_plan,
            :presence => true
end
