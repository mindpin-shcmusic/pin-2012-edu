class ChangeHomeworkUploadsAndAttachmentsToUseFileEntity < ActiveRecord::Migration
  def change
    create_table :homework_attachments do |t|
      t.integer :creator_id
      t.integer :homework_id
      t.integer :file_entity_id
      t.string  :name
      t.timestamps
    end
  end
end
