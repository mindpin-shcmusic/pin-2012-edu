# -*- coding: utf-8 -*-
class HomeworkTeacherAttachement < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'
  
  # 老师上传作业提交物路径
  has_attached_file :attachement,
                    :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"

end
