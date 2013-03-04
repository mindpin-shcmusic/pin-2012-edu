# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  class InvalidCourseParams < Exception;end
  class AssignMultiTeachersOfSameCourse < Exception;end

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }

  has_many :course_resources
  has_many :teaching_plans

  belongs_to :cover,
             :class_name  => 'CourseResource',
             :foreign_key => :cover_id

  has_many :file_entities, :through=> :course_resources

  has_many :course_teachers
  has_many :teacher_users, :through => :course_teachers

  scope :with_semester, lambda {|semester|
    joins(:course_teachers).where('course_teachers.semester_value = ?', semester.value)
  }

  include Pacecar

  def destroyable_by?(user)
    user.is_admin?
  end

  def cover_url
    self.cover ? self.cover.file_entity.http_url : self.default_cover
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

  def set_teachers(options)
    raise InvalidCourseParams.new if options[:semester].blank? || options[:teacher_users].nil?
    old_teacher_users = self.get_teachers :semester => options[:semester]
    new_teacher_users = options[:teacher_users]

    remove_teacher_users = old_teacher_users - new_teacher_users
    add_teacher_users = new_teacher_users - old_teacher_users
    # 删除
    remove_teacher_users.each do |user|
      course_teacher = self.course_teachers.where(
        :semester_value => options[:semester].value,
        :teacher_user_id => user.id
      ).first
      course_teacher.destroy
    end
    # 增加
    add_teacher_users.each do |user|
      self.add_teacher(
        :semester => options[:semester],
        :teacher_user => user
      )
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

  def get_students(options = {})
    if options.blank?
      return User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.course_id = #{self.id}").uniq
    end

    raise InvalidCourseParams.new if options[:semester].blank?

    if options[:teacher_user].blank?
      User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.course_id = #{self.id} and course_student_assigns.semester_value = '#{options[:semester].value}'")
    else
      User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.teacher_user_id = #{options[:teacher_user].id} and course_student_assigns.course_id = #{self.id} and course_student_assigns.semester_value = '#{options[:semester].value}'")
    end
  end

  def get_current_students_of(teacher_user)
    self.get_students(:semester => Semester.now, :teacher_user => teacher_user)
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

  def get_teacher_of(student_user,semester = Semester.now)
    User.joins("inner join course_student_assigns on course_student_assigns.teacher_user_id = users.id").
      where("course_student_assigns.student_user_id = #{student_user.id} and course_student_assigns.course_id = #{self.id} and course_student_assigns.semester_value = '#{semester.value}'").first
  end

  def get_teaching_plan(current_user)
    if self.teaching_plans.blank?
      self.teaching_plans.create(
        :title => self.name,
        :desc => self.name,
        :creator => current_user
      )
    else
      self.teaching_plans.first
    end
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

    def get_teacher_current_courses
      self.get_teacher_courses(:semester => Semester.now)
    end

    def get_teacher_course_teachers(options)
      raise '该用户不是 teacher' if !self.is_teacher?

      CourseTeacher.where("course_teachers.semester_value = '#{options[:semester].value}' and course_teachers.teacher_user_id = #{self.id}")
    end

    def get_teachers(options)
      raise '该用户不是 student' if !self.is_student?

      User.joins("inner join course_student_assigns on course_student_assigns.teacher_user_id = users.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}").group('users.id')
    end

    def get_students(options)
      raise '该用户不是 teacher' if !self.is_teacher?

      User.joins("inner join course_student_assigns on course_student_assigns.student_user_id = users.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.teacher_user_id = #{self.id}").group('users.id')
    end

    def get_students_of_the_same_teachers(options)
      raise '该用户不是 student' if !self.is_student?

      users = User.joins('inner join course_student_assigns as a1 on a1.student_user_id = users.id').
        joins('inner join course_student_assigns as a2 on a2.teacher_user_id = a1.teacher_user_id and a2.semester_value = a1.semester_value and a2.course_id = a1.course_id').
        where("a2.semester_value = '#{options[:semester].value}' and a2.student_user_id = #{self.id}").group('users.id')

      users = users - [self]
      users
    end

    def get_teachers_of_the_same_courses(options)
      raise '该用户不是 teacher' if !self.is_teacher?

      users = User.joins('inner join course_teachers on course_teachers.teacher_user_id = users.id').
        joins('inner join course_teachers as ct1 on ct1.course_id = course_teachers.course_id and ct1.semester_value = course_teachers.semester_value').
        where("ct1.semester_value = '#{options[:semester].value}' and ct1.teacher_user_id = #{self.id}").group('users.id')

      users = users - [self]
      users
    end

    def course_time_expression_collection_map
      course_teachers = __current_semester_course_teachers
      CourseTimeExpressionCollectionMap.new(course_teachers)
    end

    # 一周需要去听的课（学生 / 老师）的课时数
    def get_course_hours_count
      course_time_expression_collection_map.course_hours_count
    end

    def __current_semester_course_teachers
      if self.is_student?
        course_teachers = self.get_student_course_teachers(:semester => Semester.now)
      end

      if self.is_teacher?
        course_teachers = self.get_teacher_course_teachers(:semester => Semester.now)
      end

      course_teachers
    end

  end

  define_index do
    indexes name, :sortable => true

    where('is_removed = 0')
  end

  include ModelRemovable
  include Paginated
end
