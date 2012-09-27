class CourseTeacherTeam < ActiveRecord::Base
  belongs_to :course_teacher
  belongs_to :team

  validates :course_teacher_id, :presence => true
  validates :team_id, :presence => true
end
