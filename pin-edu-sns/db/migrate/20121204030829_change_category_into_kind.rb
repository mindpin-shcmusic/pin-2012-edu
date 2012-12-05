class ChangeCategoryIntoKind < ActiveRecord::Migration
  def change
    rename_column :upload_documents, :category, :kind
  end
end
