class CreateFileEntityOssObjects < ActiveRecord::Migration
  def change
    create_table :file_entity_oss_objects do |t|
      t.integer :file_entity_id
      t.integer :saved_size, :limit => 8
      t.string :upload_id
      t.boolean :uploaded
      t.timestamps
    end
  end
end
