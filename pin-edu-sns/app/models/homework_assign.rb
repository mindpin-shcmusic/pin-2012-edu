# -*- coding: utf-8 -*-
class HomeworkAssign < ActiveRecord::Base
  # --- 模型关联
  belongs_to :homework, :class_name => 'Homework'
  belongs_to :student
end
