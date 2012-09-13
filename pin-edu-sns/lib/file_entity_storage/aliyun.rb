module FileEntityStorage
  module Aliyun
    def self.included(base)
      # 这个声明只是为了和 filesystem 接口统一，
      # 只负责 attach.url 的读取
      base.has_attached_file :attach,
                        :path => R::FILE_ENTITY_ATTACHED_PATH,
                        :url  => R::FILE_ENTITY_ATTACHED_URL

      base.send(:include, InstanceMethods)
      base.has_many :file_entity_oss_objects, :order => 'id ASC'
    end

    module InstanceMethods
      class ObjectSizeOverflowError < StandardError;end

      def save_first_blob(blob)
        save_new_blob(blob)
      end

      def save_new_blob(blob)
        blob_size = blob.size
        current_object.save_new_blob(blob)

        self.saved_size += blob_size
        self.save
        check_completion_status
      end

      def current_object
        object = self.file_entity_oss_objects.last || self.file_entity_oss_objects.create
        object = self.file_entity_oss_objects.create if object.complete?
        object
      end

      def check_completion_status
        return if !complete?

        UploadFileEntityToAliyunOssResqueQueue.enqueue(self.id)
      end

      def upload_to_oss
        self.file_entity_oss_objects.each{ |object| object.upload_to_oss }

        # 创建 object_group
        object_names = self.file_entity_oss_objects.map(&:object_name)
        OssManager::OSS_BUCKET.object(object_name).group(object_names)
      end

      def complete?
        return true if self.saved_size == self.attach_file_size
        return false if self.saved_size < self.attach_file_size
        raise ObjectSizeOverflowError
      end

      def object_name
        self.attach.url.gsub(/\?.*/,"")
      end
      
    end
  end
end