# -*- encoding : utf-8 -*-
class RemoveAttachementFromHomeworkTeacherAttachement < ActiveRecord::Migration
  def up
    remove_column :homework_teacher_attachements, :attachement
  end

  def down
  end
end
