class TestPaperTestQuestion < ActiveRecord::Base
  belongs_to :test_paper
  belongs_to :test_question

  validates :test_paper,
            :test_question,
            :presence => true
end
