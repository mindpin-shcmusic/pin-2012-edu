class UploadFileEntityToAliyunOssResqueQueue
  QUEUE_NAME = :upload_file_entity_to_aliyun_oss_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(file_entity_id)
    Resque.enqueue(UploadFileEntityToAliyunOssResqueQueue, file_entity_id)
  end

  def self.perform(file_entity_id)
    file_entity = FileEntity.find(file_entity_id)
    file_entity.upload_to_oss
  end
end
