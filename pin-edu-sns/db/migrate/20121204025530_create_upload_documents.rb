class CreateUploadDocuments < ActiveRecord::Migration
  def change
    create_table :upload_documents do |t|
      # 关联 upload_document_dirs 表 ID
      t.integer :dir_id
      t.string  :title

      # ['TEXT', 'WORD', 'EXCEL']
      t.string  :category
      t.text    :content
      t.integer :file_entity_id

      t.timestamps
    end
  end
end
