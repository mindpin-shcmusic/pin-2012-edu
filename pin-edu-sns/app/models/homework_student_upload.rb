# -*- coding: utf-8 -*-
class HomeworkStudentUpload < ActiveRecord::Base
  # --- 模型关联
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  belongs_to :homework_student_upload_requirement,
             :class_name => 'HomeworkStudentUploadRequirement',
             :foreign_key => 'requirement_id'

  belongs_to :file_entity

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :homework_student_uploads,
                    :class_name => 'HomeworkStudentUpload',
                    :foreign_key => 'creator_id'

      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      # 学生是否提交作业附件
      def is_upload_homework_attachment?(attachment)
        self.homework_student_uploads.where(:requirement_id => attachment.id).exists?
      end
      
      # 学生上传作业提交物的数量
      # 参数 homework 是一个实例变量
      def uploaded_count_of_homework(homework)
        count = 0
        homework.homework_student_upload_requirements.each do |attachment|
          count += 1 if HomeworkStudentUpload.where(:creator_id => self.id, :requirement_id => attachment.id).exists?
        end
        return count
      end
      
    end
  end
end
