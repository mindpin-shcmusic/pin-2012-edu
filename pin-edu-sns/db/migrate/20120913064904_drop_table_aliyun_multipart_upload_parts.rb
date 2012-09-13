class DropTableAliyunMultipartUploadParts < ActiveRecord::Migration
  def change
    drop_table :aliyun_multipart_upload_parts
  end
end
