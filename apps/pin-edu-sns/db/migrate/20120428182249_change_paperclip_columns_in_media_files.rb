class ChangePaperclipColumnsInMediaFiles < ActiveRecord::Migration
  def change
    rename_column :media_files, :file_file_name, :entry_file_name
    rename_column :media_files, :file_content_type, :entry_content_type
    rename_column :media_files, :file_file_size, :entry_file_size
    rename_column :media_files, :file_updated_at, :entry_updated_at
  end
end
