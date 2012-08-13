# -*- coding: utf-8 -*-
class Course < ActiveRecord::Base
  belongs_to :teacher

  has_many :course_students
  has_many :students, :through => :course_students

  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }

  has_many :courses_images
  has_many :file_entities, :through=> :courses_images

  def cover
    self.cover_courses_image ? self.cover_courses_image.file_entity.attach.url : self.default_cover
  end

  def default_cover
    '/assets/covers/course.small.jpg'
  end

  def get_user_ids
    [students, teacher].flatten.map(&:user_id).sort
  end

  def get_users
    User.find get_user_ids
  end

  def create_courses_image(file)
    raise "请选择图片上传" if :image != FileEntity.content_kind(file.content_type)

    raise "请选择上传文件" if file.blank?
    file_entity = FileEntity.create(:attach => file, :merged => true)
    courses_image = CoursesImage.create(:file_entity=>file_entity,:course=>self,:kind=>CoursesImage::Kind::ATTACHMENT)
    raise courses_image.errors.first[1] if !courses_image.valid?
  end

  def cover_courses_image
    self.courses_images.find_by_kind(CoursesImage::Kind::COVER)
  end

  def select_cover(courses_image)
    if !self.cover_courses_image.blank?
      self.cover_courses_image.update_attributes(:kind=>CoursesImage::Kind::ATTACHMENT)
    end
    courses_image.update_attributes(:kind=>CoursesImage::Kind::COVER)
  end

  def self.import_from_csv(file)
    ActiveRecord::Base.transaction do
      parse_csv_file(file) do |row,index|
        course = Course.new(
        :name => row[0], :cid => row[1], :department => row[2],
        :location => row[3], :desc => row[4])
        if !course.save
          message = course.errors.first[1]
          raise "第 #{index+1} 行解析出错,可能的错误原因 #{message} ,请修改后重新导入"
        end
      end
    end
  end

  module UserMethods
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def courses
        if self.is_teacher?
          self.teacher.courses
        elsif self.is_student?
          self.student.courses
        end
      end

      def courses=(courses)
        if self.is_teacher?
          self.teacher.courses = courses
        elsif self.is_student?
          self.student.courses = courses
        end
      end
    end
  end

  define_index do
    indexes name, :sortable => true

    where('is_removed = 0')
  end

  include ModelRemovable
  include Paginated
end
