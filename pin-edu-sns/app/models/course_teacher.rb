class CourseTeacher < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id

  has_many :course_teacher_teams
  has_many :teams, :through => :course_teacher_teams

  validates :course_id, :presence => true
  validates :teacher_user_id, :presence => true

  module UserMethods
    def self.included(base)
      base.has_many :course_teachers, :foreign_key => :teacher_user_id
      base.has_many :courses, :through => :course_teachers
    end
  end
end
