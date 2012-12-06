class AddFileNameToUploadDocuments < ActiveRecord::Migration
  def change
     add_column :upload_documents, :file_name, :string
  end
end
