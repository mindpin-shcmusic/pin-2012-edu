class TeachingPlan < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id


  belongs_to :course

  has_many :chapters
  has_many :test_questions
  has_many :homeworks
  
  validates :title, :desc, :creator, :course, :presence => true
  validates :course_id, :presence => true

  def get_test_paper_for(student_user)
    TestPaper.where(:teaching_plan_id => self.id, :student_user_id => student_user.id).first
  end

  def make_test_paper_for(student_user)
    paper = TestPaper.find_or_initialize_by_teaching_plan_id_and_student_user_id(self.id, student_user.id)
    paper.save
    paper.select_questions
    paper
  end

  def can_write?(current_user)
    current_user.is_teacher?
  end

  def can_read?(current_user)
    return true if can_write?(current_user)
    self.course.get_students.include?(current_user)
  end

  module UserMethods
    def self.included(base)
      base.has_many :teaching_plans, :class_name => 'TeachingPlan', :foreign_key => :creator_id
    end
  end

end
