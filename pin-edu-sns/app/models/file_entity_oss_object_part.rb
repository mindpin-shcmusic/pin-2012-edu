class FileEntityOssObjectPart < ActiveRecord::Base
  # 每次通过 multipart upload 上传给 OSS 的片段大小
  PART_SIZE = 8388608

  belongs_to :file_entity

  before_validation(:on => :create) do |object_part|
    object_part.saved_size = 0
  end

  after_create do |object_part|
    dir = File.dirname(object_part.part_path)
    FileUtils.mkdir_p(dir)
  end

  def complete?
    return true if self.saved_size == FileEntityOssObjectPart::PART_SIZE 
    return false if self.saved_size < FileEntityOssObjectPart::PART_SIZE 
    # 如果已保存的尺寸 > FileEntityOssObjectPart::PART_SIZE，只能是异常了。
    raise ObjectSizeOverflowError 
  end

  def save_new_blob(blob)
    # 保存并即时合并文件片段
    blob_size = blob.size
    File.open(part_path,"a") do |src_f|
      File.open(blob.path,'r') do |f|
        src_f << f.read
      end
    end

    self.saved_size += blob_size
    self.save
  end

  def part_path
    "#{MINDPIN_MRS_DATA_PATH}/oss_object_parts/#{id}/part"
  end

  class ObjectSizeOverflowError < StandardError;end
end
