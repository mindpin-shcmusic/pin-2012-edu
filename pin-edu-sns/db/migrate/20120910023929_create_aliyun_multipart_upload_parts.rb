class CreateAliyunMultipartUploadParts < ActiveRecord::Migration
  def change
    create_table :aliyun_multipart_upload_parts do |t|
      t.integer :file_entity_id
      t.string :upload_id
      t.integer :part_num
      t.string :md5
      t.timestamps
    end
  end
end
