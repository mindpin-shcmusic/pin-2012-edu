class TeachingPlan < ActiveRecord::Base
  include ModelRemovable
  include Pacecar
  class AddStudentToMultiTeachingPlanError < Exception;end

  validates :title, :semester_value, :content, :presence => true
  has_many :teams

  validate :checkout_semester
  def checkout_semester
    if self.semester.blank?
      errors.add :semester_value, '学期不能为空' 
    end
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

  def destroyable_by?(user)
    user.is_admin?
  end

end
