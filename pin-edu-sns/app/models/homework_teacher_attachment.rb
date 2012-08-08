# -*- coding: utf-8 -*-
class HomeworkTeacherAttachment < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'
  
  belongs_to :file_entity
end
