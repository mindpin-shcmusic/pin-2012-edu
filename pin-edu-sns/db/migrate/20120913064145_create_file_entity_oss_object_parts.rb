class CreateFileEntityOssObjectParts < ActiveRecord::Migration
  def change
    create_table :file_entity_oss_object_parts do |t|
      t.integer :file_entity_oss_object
      t.integer :saved_size, :limit => 8
      t.timestamps
    end
  end
end
