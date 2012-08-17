class DropSliceTempFiles < ActiveRecord::Migration
  def change
    drop_table :slice_temp_files
  end
end
