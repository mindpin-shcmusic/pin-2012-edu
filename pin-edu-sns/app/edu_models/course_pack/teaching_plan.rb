class TeachingPlan < ActiveRecord::Base
  belongs_to :course

  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  has_many :chapters
  
  validates :title, :desc, :course, :teacher_user, :semester_value, :presence => true
  
end
