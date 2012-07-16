class AddRealFileNameColumnToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :real_file_name, :string
  end
end
