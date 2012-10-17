class CourseSurvey < ActiveRecord::Base
  has_many :course_survey_records, :dependent => :destroy
  has_many :course_survey_es_records, :dependent => :destroy
  belongs_to :course_teacher

  validates :title, :presence => true

  scope :with_kind, lambda {|kind| {:conditions => ['kind = ?', kind]}}

  def has_permission?(student_user)
    return false if !student_user.is_student?

    course_teacher.course.get_students(
      :semester => course_teacher.semester,
      :teacher_user => course_teacher.teacher_user
    ).include?(student_user)
  end
end
