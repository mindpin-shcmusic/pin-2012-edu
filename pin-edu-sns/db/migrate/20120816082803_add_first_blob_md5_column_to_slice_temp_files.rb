class AddFirstBlobMd5ColumnToSliceTempFiles < ActiveRecord::Migration
  def change
    add_column :slice_temp_files, :first_blob_md5, :string
  end
end
