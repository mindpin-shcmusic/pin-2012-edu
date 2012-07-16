class ChangeUuidToSliceTempFileIdInMediaFiles < ActiveRecord::Migration
  def change
    rename_column(:media_files, :uuid, :slice_temp_file_id)
  end
end
