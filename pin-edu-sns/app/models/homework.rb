# -*- coding: utf-8 -*-
class Homework < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  belongs_to :course

  has_many :homework_requirements
  accepts_nested_attributes_for :homework_requirements

  has_many :homework_assigns

  has_many :assigned_students,
           :through => :homework_assigns,
           :source => :student
  
  # 没有提交作业的学生
  has_many :not_submitted_students,
           :through => :homework_assigns,
           :source => :student,
           :conditions => ['homework_assigns.is_submit = ?', false]
  
  # 已经提交作业的学生
  has_many :submitted_students,
           :through => :homework_assigns,
           :source => :student,
           :conditions => ['homework_assigns.is_submit = ?', true]
  
  # 学生附件
  has_many :homework_student_uploads
  
  # 老师创建作业时上传的附件
  has_many :homework_teacher_attachments
  
  accepts_nested_attributes_for :homework_assigns
  
  # --- 校验方法
  validates :title, :content, :presence => true
  validates :course, :presence => true
  
  def assigned_by_student(student)
    self.homework_assigns.find_by_student_id(student.id)
  end
  
  # 学生是否被分配
  def has_assigned(student)
    self.homework_assigns.where(:student_id => student.id).any?
  end
  
  def has_finished_for?(student)
    raise "学生#{student.id}没有被分配作业#{self.id}" unless self.has_assigned(student)
    self.assigned_by_student(student).has_finished
  end

  def set_finished_for!(student)
    self.assigned_by_student(student).update_attribute :has_finished, true
  end

  # 老师创建作业时生成的附件压缩包
  def build_teacher_attachments_zip(user)
    path = "/MINDPIN_MRS_DATA/attachments/homework_attachments/homework_teacher#{user.id}_#{self.id}.zip"
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |zip|
      self.homework_teacher_attachments.each do |attachment|
        unless zip.find_entry(attachment.name)
          zip.add(attachment.name, attachment.file_entity.attach.path)
        end
      end
    end
  end
  
  # 压缩学生提交的附件
  def build_student_uploads_zip(user)#, homework_student_upload, old_file = '')
    homework_id = self.id
    path = "/MINDPIN_MRS_DATA/attachments/homework_attachments/homework_student#{user.id}_#{self.id}.zip"
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |zip|
      self.homework_student_uploads.where(:creator_id => user.id).each do |upload|
        zip.add(upload.name, upload.file_entity.attach.path)
      end
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
      base.has_many :homeworks,
                    :foreign_key => :creator_id

      # 老师未过期作业
      base.has_many :undeadline_teacher_homeworks,
                    :class_name => 'Homework',
                    :foreign_key => :creator_id,
                    :conditions => [
                      'deadline > ?',
                      Time.new.strftime("%Y-%m-%d %H:%M:%S")
                    ]
      
      # 老师已过期作业
      base.has_many :deadline_teacher_homeworks,
                    :class_name => 'Homework',
                    :foreign_key => :creator_id,
                    :conditions => ['deadline <= ?', Time.now]
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def deadline_homeworks
        if self.is_teacher?
          deadline_teacher_homeworks
        elsif self.is_student?
          deadline_student_homeworks
        end
      end

      def undeadline_homeworks
        if self.is_teacher?
          undeadline_teacher_homeworks
        elsif self.is_student?
          undeadline_student_homeworks
        end
      end

      def deadline_student_homeworks
        self.student_homeworks.where('deadline <= ?', Time.now)
      end

      def undeadline_student_homeworks
        self.student_homeworks.where('deadline > ?', Time.now)
      end

      def student_homeworks
        raise "#User-#{self.id}: 该用户不是学生" unless self.is_student?
        Homework.joins(:homework_assigns).where('homework_assigns.student_id = ?', self.student.id)
      end
    end
  end
  include HomeworkAssignRule::HomeworkMethods
  include Comment::CommentableMethods
end
