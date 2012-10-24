class CourseStudentAssign < ActiveRecord::Base
  belongs_to :course
  belongs_to :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id
  belongs_to :student_user,
             :class_name  => 'User',
             :foreign_key => :student_user_id

  has_one :course_student_score

  validates :course_id, :presence => true
  validates :teacher_user_id, :presence => true
  validates :student_user_id, :presence => true,
    :uniqueness => {:scope => [:course_id,:semester_value]}

  def semester=(semester)
    @semester = semester
    self.semester_value = semester.value
  end

  def semester
    @semester
  end
end
