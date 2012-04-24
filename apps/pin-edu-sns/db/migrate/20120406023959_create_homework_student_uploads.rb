# -*- encoding : utf-8 -*-
class CreateHomeworkStudentUploads < ActiveRecord::Migration
  def change
    create_table :homework_student_uploads do |t|
      t.integer :creator_id
      t.integer :attachement_id
      
      t.string :attachement_file_name
      t.string :attachement_content_type
      t.integer :attachement_file_size
      t.datetime :attachement_updated_at
      
      t.timestamps
    end
  end
end
