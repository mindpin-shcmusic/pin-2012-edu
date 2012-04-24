# -*- encoding : utf-8 -*-
class ChangeTitleFromHomeworkTeacherAttachement < ActiveRecord::Migration
  def change
    rename_column :homework_teacher_attachements, :title, :attachement
  end
end
