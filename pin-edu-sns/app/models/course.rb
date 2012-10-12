# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  class InvalidCourseParams < Exception;end

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }

  has_many :course_images
  has_many :course_videos

  belongs_to :cover,
             :class_name  => 'CourseImage',
             :foreign_key => :cover_id

  has_many :file_entities, :through=> :course_images

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

  def create_course_image(file)
    raise "请选择上传文件" if file.blank?

    raise "请选择图片上传" if :image != FileEntity.content_kind(file.content_type)
    file_entity = FileEntity.create(:attach => file, :merged => true)
    course_image = CourseImage.create(:file_entity=>file_entity,:course=>self)
    raise course_image.errors.first[1] if !course_image.valid?
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

  module UserMethods
    def add_course(options)
      raise InvalidCourseParams.new if options[:course].blank? || options[:semester].blank? || options[:teacher_user].blank?
      
      course_teacher = CourseTeacher.get_by_params(options[:course], options[:semester], options[:teacher_user])
      raise InvalidCourseParams.new if course_teacher.blank?

      CourseStudentAssign.create(
        :teacher_user => options[:teacher_user],
        :student_user => self,
        :semester => options[:semester],
        :course => options[:course]
      )
    end

    def get_courses(options)
      Course.joins("inner join course_student_assigns on course_student_assigns.course_id = courses.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}")
    end

    def get_teachers(options)
      User.joins("inner join course_student_assigns on course_student_assigns.teacher_user_id = users.id").
        where("course_student_assigns.semester_value = '#{options[:semester].value}' and course_student_assigns.student_user_id = #{self.id}")
    end
  end

  define_index do
    indexes name, :sortable => true

    where('is_removed = 0')
  end

  include ModelRemovable
  include Paginated
end
