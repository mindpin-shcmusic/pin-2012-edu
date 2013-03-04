class TestQuestion < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  belongs_to :teaching_plan

  has_many   :test_paper_test_questions

  has_many   :test_papers,
             :through => :test_paper_test_questions

  validates :title, :teaching_plan, :creator, :presence => true

  include ModelRemovable


  def destroyable_by?(user)
    user.is_teacher?
  end
end
