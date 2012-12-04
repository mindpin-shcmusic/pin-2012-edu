class CreateUploadDocumentDirs < ActiveRecord::Migration
  def change
    create_table :upload_document_dirs do |t|
      t.integer :dir_id
      t.string  :name
      t.boolean  :is_removed
      t.integer :files_count

      t.timestamps
    end
  end
end
