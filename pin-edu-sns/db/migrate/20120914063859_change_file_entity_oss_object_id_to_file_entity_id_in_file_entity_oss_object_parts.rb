class ChangeFileEntityOssObjectIdToFileEntityIdInFileEntityOssObjectParts < ActiveRecord::Migration
  def change
    rename_column :file_entity_oss_object_parts, :file_entity_oss_object_id, :file_entity_id
  end
end
