class AddDefaultBooleanValue < ActiveRecord::Migration
  def change
    change_column :upload_document_dirs, :is_removed, :boolean, :default => false
  end
end
