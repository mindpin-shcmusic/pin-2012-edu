# -*- encoding : utf-8 -*-
class CreateHomeworkTeacherAttachements < ActiveRecord::Migration
  def change
    create_table :homework_teacher_attachements do |t|
      t.integer :creator_id
      t.integer :homework_id
      t.string :title
      
      t.timestamps
    end
  end
end
