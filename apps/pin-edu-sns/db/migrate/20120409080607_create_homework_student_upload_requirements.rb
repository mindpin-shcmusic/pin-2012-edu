# -*- encoding : utf-8 -*-
class CreateHomeworkStudentUploadRequirements < ActiveRecord::Migration
  def change
    create_table :homework_student_upload_requirements do |t|
      t.integer :creator_id
      t.integer :homework_id
      t.string :title
      
      t.timestamps
    end
  end
end
