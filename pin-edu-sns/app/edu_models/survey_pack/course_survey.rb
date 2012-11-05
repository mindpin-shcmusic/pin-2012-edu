class CourseSurvey < ActiveRecord::Base
  has_many :course_survey_records, :dependent => :destroy
  has_many :course_survey_es_records, :dependent => :destroy
  belongs_to :course_teacher

  validates :title, :presence => true

  include CourseTeacherRelativeMethods

  scope :with_kind, lambda {|kind| {:conditions => ['kind = ?', kind]}}
  scope :with_student, lambda { |student_user| 
    joins("inner join course_student_assigns on course_surveys.course_id = course_student_assigns.course_id and course_surveys.semester_value = course_student_assigns.semester_value and course_surveys.teacher_user_id = course_student_assigns.teacher_user_id").
      where("course_student_assigns.student_user_id = #{student_user.id}")
  }

  scope :with_teacher, lambda {|user| {:conditions => ['teacher_user_id = ?', user.id]}}


  def has_permission?(student_user)
    return false if !student_user.is_student?

    course_teacher.course.get_students(
      :semester => course_teacher.semester,
      :teacher_user => course_teacher.teacher_user
    ).include?(student_user)
  end

  def finished_ratio
    count = (self.kind == '1' ? self.course_survey_records : self.course_survey_es_records).count
    total = self.course.get_students(:semester     => self.semester,
                                     :teacher_user => self.teacher_user).count
    "#{count}/#{total}"
  end

end
