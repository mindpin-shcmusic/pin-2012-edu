class FileEntityOssObject < ActiveRecord::Base
  # 64M
  OBJECT_SIZE = 67108864

  has_many :file_entity_oss_object_parts, :order => 'id ASC'

  before_validation(:on => :create) do |oss_object|
    oss_object.saved_size = 0
  end

  def complete?
    return true if self.saved_size == FileEntityOssObject::OBJECT_SIZE
    return false if self.saved_size < FileEntityOssObject::OBJECT_SIZE
    raise ObjectSizeOverflowError # 如果已保存的尺寸 > FileEntityOssObject::OBJECT_SIZE，只能是异常了。
  end

  def save_new_blob(blob)
    blob_size = blob.size
    current_part.save_new_blob(blob)

    self.saved_size += blob_size
    self.save
  end

  def upload_to_oss
    return if uploaded?

    multipart_upload = OssManager::OSS_BUCKET.object(object_name).multipart_upload
    self.update_attributes!( :upload_id => multipart_upload.init )

    part_infos = []
    self.file_entity_oss_object_parts.each_with_index do |part, index|
      part_infos << multipart_upload.upload(upload_id, index+1, File.open(part.part_path,'r'))
    end
    multipart_upload.complete(upload_id, part_infos)

    self.update_attributes!( :uploaded => true )
  end

  def current_part
    part = self.file_entity_oss_object_parts.last || self.file_entity_oss_object_parts.create
    part = self.file_entity_oss_object_parts.create if part.complete?
    part
  end

  def object_name
    "file_entity_oss_objects/#{self.id}"
  end

  class ObjectSizeOverflowError < StandardError;end
end
