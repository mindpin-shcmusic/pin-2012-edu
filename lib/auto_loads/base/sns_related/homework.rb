class Homework < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  has_many :homework_assigns
  has_many :homework_student_upload_requirements
  accepts_nested_attributes_for :homework_student_upload_requirements
  
  # 未提交作业学生
  has_many :unsubmitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', false]
  
  # 已提交作业学生
  has_many :submitted_students, :through => :homework_assigns, :source => :creator, :conditions => ['is_submit = ?', true]
  
  # 学生附件
  has_many :homework_student_upload_requirements
  
  # 老师创建作业时上传的附件
  has_many :homework_teacher_attachements
  
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  
  def assigned_by_student(student)
    self.homework_assigns.where(:student_id => student.id).first
  end
  
  # 学生是否被分配
  def has_assigned(student)
    self.homework_assigns.where(:student_id => student.id).exists?
  end
  
  
  # 老师创建作业时生成的附件压缩包
  def build_teacher_attachements_zip(user)
    zipfile_name = "/web/2012/homework_teacher_attachements/homework_teacher#{user.id}_#{self.id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      self.homework_teacher_attachements.each do |file|
        unless zipfile.find_entry(file.attachement_file_name)
          zipfile.add(file.attachement_file_name, file.attachement.path)
        end
      end
    end
  end
  
  # 压缩学生提交的附件
  def build_student_attachements_zip(user, homework_student_upload, old_file = '')
    # homework_id = homework_student_upload.homework_student_upload_requirement.homework.id
    homework_id = self.id
    zipfile_name = "/web/2012/homework_student_uploads/homework_student#{user.id}_#{homework_id}.zip"
    Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
      zipfile.remove(old_file) if zipfile.find_entry(old_file) && old_file != ''
      zipfile.add(homework_student_upload.attachement_file_name, homework_student_upload.attachement.path)
    end
  end
  
  # 学生提交作业
  def submit_by_student(user, content = '')
    homework_assign = self.homework_assigns.find_by_student_id(user.id)
    homework_assign.content = content
    homework_assign.is_submit = true
    homework_assign.has_finished = true
    homework_assign.submitted_at = DateTime.now
    homework_assign.save
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homeworks, :foreign_key => :creator_id
      
      # 老师未过期作业
      base.has_many :undeadline_teacher_homeworks, :class_name => 'Homework', :foreign_key => :creator_id, :conditions => ['deadline > ?', Time.new.strftime("%Y-%m-%d %H:%M:%S")]
      
      # 老师已过期作业
      base.has_many :deadline_teacher_homeworks, :class_name => 'Homework', :foreign_key => :creator_id, :conditions => ['deadline <= ?', Time.now]
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # nothing ...
    end
  end
end
