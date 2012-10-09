class DropTableFileEntityOssObjects < ActiveRecord::Migration
  def change
    drop_table :file_entity_oss_objects
  end
end
