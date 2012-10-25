# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  class InvalidCourseParams < Exception;end
  class AssignMultiTeachersOfSameCourse < Exception;end

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }

  has_many :course_resources

  belongs_to :cover,
             :class_name  => 'CourseResource',
             :foreign_key => :cover_id

  has_many :file_entities, :through=> :course_resources

  has_many :course_teachers
  has_many :teacher_users, :through => :course_teachers

  has_many :teaching_plan_courses
  has_many :teaching_plans, :through => :teaching_plan_courses

  def cover_url
    self.cover ? self.cover.file_entity.attach.url : self.default_cover
  end

  def default_cover
    '/assets/covers/course.small.jpg'
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        course = Course.new(
        :name => row[0], :cid => row[1], :desc => row[4])
        if !course.save
          message = course.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  def add_teacher(options)
    raise InvalidCourseParams.new if options[:semester].blank? || options[:teacher_user].blank?
    CourseTeacher.create(
      :teacher_user => options[:teacher_user],
      :semester => options[:semester],
      :course => self
    )
  end

  def get_teachers(options)
    raise InvalidCourseParams.new if options[:semester].blank?
    User.joins("inner join course_teachers on course_teachers.teacher_user_id = users.id").
      where("course_teachers.course_id = #{self.id} and course_teachers.semester_value = '#{options[:semester].value}'")
  end

  def get_students(options)
    raise InvalidCourseParams.new if options[:semester].blank?

    if options[:teacher_user].blank?
      User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.course_id = #{self.id} and course_student_assigns.semester_value = '#{options[:semester].value}'")
    else
      User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.teacher_user_id = #{options[:teacher_user].id} and course_student_assigns.course_id = #{self.id} and course_student_assigns.semester_value = '#{options[:semester].value}'")
    end
  end

  def set_course_time(options)
    raise InvalidCourseParams.new if options[:semester].blank? || options[:teacher_user].blank? || options[:time].blank?

    course_teacher = CourseTeacher.get_by_params(self, options[:semester], options[:teacher_user])
    raise InvalidCourseParams.new if course_teacher.blank?

    course_teacher.time_expression_array = options[:time]
    course_teacher.save
  end

  def get_semesters
    CourseTeacher.where(:course_id=>self.id).group(:semester_value).map do |course_teacher|
      course_teacher.semester
    end
  end

  def current_semester_users
    semester = Semester.now
    (self.get_teachers(:semester => semester) +
     self.get_students(:semester => semester)).flatten.uniq
  end

  module UserMethods
    def add_course(options)
      raise InvalidCourseParams.new if options[:course].blank? || options[:semester].blank? || options[:teacher_user].blank?
      
      course_teacher = CourseTeacher.get_by_params(options[:course], options[:semester], options[:teacher_user])
      raise InvalidCourseParams.new if course_teacher.blank?

      course_student_assign = CourseStudentAssign.where(
        :student_user_id => self.id,
        :semester_value => options[:semester].value,
        :course_id => options[:course].id
      ).first

      raise AssignMultiTeachersOfSameCourse.new if !course_student_assign.blank?

      CourseStudentAssign.create(
        :teacher_user => options[:teacher_user],
        :student_user => self,
        :semester => options[:semester],
        :course => options[:course]
      )
    end

    def get_student_courses(options)
      raise '该用户不是 student' if !self.is_student?

      Course.joins("inner join course_student_assigns on course_student_assigns.course_id = courses.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}")
    end

    def get_student_course_teachers(options)
      raise '该用户不是 student' if !self.is_student?

      CourseTeacher.joins("inner join course_student_assigns on course_student_assigns.course_id = course_teachers.course_id and course_student_assigns.semester_value = course_teachers.semester_value and course_student_assigns.teacher_user_id = course_teachers.teacher_user_id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}")
    end

    def get_teacher_courses(options)
      raise '该用户不是 teacher' if !self.is_teacher?

      Course.joins("inner join course_teachers on course_teachers.course_id = courses.id").
        where("course_teachers.semester_value = '#{options[:semester].value}' and course_teachers.teacher_user_id = #{self.id}")
    end

    def get_teacher_course_teachers(options)
      raise '该用户不是 teacher' if !self.is_teacher?

      CourseTeacher.where("course_teachers.semester_value = '#{options[:semester].value}' and course_teachers.teacher_user_id = #{self.id}")
    end

    def get_teachers(options)
      User.joins("inner join course_student_assigns on course_student_assigns.teacher_user_id = users.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}")
    end

    def get_course_time(options)
      raise InvalidCourseParams.new if options[:semester].blank? || options[:teacher_user].blank? || options[:course].blank?

      course_teacher = CourseTeacher.get_by_params(options[:course], options[:semester], options[:teacher_user])
      course_teacher.time_expression_hash
    end

    def get_all_course_time(options)
      raise InvalidCourseParams.new if options[:semester].blank?
      course_teachers = CourseTeacher.get_all_by_semester(options[:semester])
      value = {}
      course_teachers.each do |course_teacher|
        value[course_teacher.course.name] = course_teacher.time_expression_hash
      end
      value
    end
  end

  define_index do
    indexes name, :sortable => true

    where('is_removed = 0')
  end

  include ModelRemovable
  include Paginated
end
