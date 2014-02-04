class AddFileMergedToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :file_merged, :boolean
  end
end
