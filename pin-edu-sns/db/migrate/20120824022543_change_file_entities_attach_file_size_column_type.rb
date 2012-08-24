class ChangeFileEntitiesAttachFileSizeColumnType < ActiveRecord::Migration
  def change
    change_column :file_entities, :attach_file_size, :integer, :limit => 8
  end
end
