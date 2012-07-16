class RemoveSliceTempFileIdFromMediaFiles < ActiveRecord::Migration
  def change
    remove_column :media_files, :slice_temp_file_id
  end
end
