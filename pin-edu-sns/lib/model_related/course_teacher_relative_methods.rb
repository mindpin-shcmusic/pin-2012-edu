module CourseTeacherRelativeMethods
  def self.included(base)
    base.send :belongs_to, :course
    base.send :belongs_to, :teacher_user,
             :class_name  => 'User',
             :foreign_key => :teacher_user_id
    base.validates :course_id, :presence => true
    base.validates :teacher_user_id, :presence => true
    base.validates :semester_value, :presence => true
    base.validate :check_course_teacher
  end

  def course_teacher
    CourseTeacher.where(
      :course_id => self.course_id,
      :teacher_user_id => self.teacher_user_id,
      :semester_value => self.semester_value
    ).first
  end

  def semester=(semester)
    @semester = semester
    self.semester_value = semester.value
  end

  def semester
    @semester || (
      if !self.semester_value.blank?
        Semester.get_by_value(self.semester_value)
      end
    )
  end

  def check_course_teacher
    if course_teacher.blank?
      self.errors.add(:base,"关联的 course_teacher 不存在")
    end
  end
end