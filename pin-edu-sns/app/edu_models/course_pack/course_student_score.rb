class CourseStudentScore < ActiveRecord::Base
  belongs_to :course_student_assign

  def student_user
    self.course_student_assign.student_user
  end

  def teacher_user
    self.course_student_assign.teacher_user
  end

  def course
    self.course_student_assign.course
  end

  def semester
    Semester.get_by_value self.course_student_assign.semester_value
  end

  module UserMethods
    def self.included(base)
      base.has_many :teacher_course_assigns,
                    :class_name  => 'CourseStudentAssign',
                    :foreign_key => :teacher_user_id

      base.has_many :student_course_assigns,
                    :class_name  => 'CourseStudentAssign',
                    :foreign_key => :student_user_id

      base.has_many :created_course_scores,
                    :through => :teacher_course_assigns,
                    :source  => :course_student_score

      base.has_many :received_course_scores,
                    :through => :student_course_assigns,
                    :source  => :course_student_score

    end
    
    def create_course_score(options)
      raise Course::InvalidCourseParams.new if options[:course].blank?   ||
                                               options[:semester].blank? ||
                                               options[:student_user].blank?

      assign = self.teacher_course_assigns.\
      find_by_semester_value_and_student_user_id_and_course_id(options[:semester].value,
                                                               options[:student_user].id,
                                                               options[:course].id)

      raise Course::InvalidCourseParams.new if assign.blank?

      CourseStudentScore.create(:course_student_assign => assign)
    end
  end

end
