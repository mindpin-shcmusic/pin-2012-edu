class TestPaper < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  validates :teaching_plan , :presence => true
  validates :student_user , :presence => true

  def select_random_questions
    questions = self.teaching_plan.test_questions
    10.times.inject({:left => questions, :selected => []}) do |acc, _|
      question = acc[:left].dup.shuffle[0]
      selected = acc[:selected].dup + [selected]
      {:left => acc[:left].dup.reject {|q| q == question}, :selected => selected}
    end[:selected]
  end
end
