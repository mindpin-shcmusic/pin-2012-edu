class TestPaper < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  has_many   :test_paper_test_questions
  has_many   :test_questions,
             :through => :test_paper_test_questions
             
  validates  :teaching_plan, :presence => true
  validates  :student_user, :presence => true

  def select_questions
    return self.test_questions = random_select_questions if self.test_questions.blank?
    self.test_questions
  end

  def random_select_questions
    questions = self.teaching_plan.test_questions
    selected_questions = 10.times.inject({:left => questions, :selected => []}) do |acc, _|
      question = acc[:left].dup.shuffle[0]
      selected = acc[:selected].dup + [question]
      {:left => acc[:left].dup.reject {|q| q == question}, :selected => selected}
    end[:selected]
  end
end
