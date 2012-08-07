class ChangeHomeworkUploadsAndAttachmentsToUseFileEntity < ActiveRecord::Migration
  def change
    change_table :homework_student_uploads do |t|
      t.remove  :attachement_file_name
      t.remove  :attachement_content_type
      t.remove  :attachement_file_size
      t.remove  :attachement_updated_at
      t.remove  :attachement_id
      t.integer :homework_id
      t.integer :file_entity_id
    end

    change_table :homework_teacher_attachments do |t|
      t.remove  :attachement_file_name
      t.remove  :attachement_content_type
      t.remove  :attachement_file_size
      t.remove  :attachement_updated_at
      t.integer :file_entity_id
    end
  end
end
