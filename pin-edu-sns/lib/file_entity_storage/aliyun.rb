module FileEntityStorage
  module Aliyun
    def self.included(base)
      # 这个声明只是为了和 filesystem 接口统一，
      # 只负责 attach.url 的读取
      base.has_attached_file :attach,
                        :path => R::FILE_ENTITY_ATTACHED_PATH,
                        :url  => R::FILE_ENTITY_ATTACHED_URL

      base.send(:include, InstanceMethods)
      base.has_many :file_entity_oss_object_parts, :order => 'id ASC'
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def create_by_params(file_name,file_size)
        self.create(
          :attach_file_name => file_name,
          :attach_content_type => file_content_type(file_name),
          :attach_file_size => file_size,
          :merged => false
        )
      end
    end

    module InstanceMethods
      class ObjectSizeOverflowError < StandardError;end

      def save_first_blob(blob)
        save_new_blob(blob)
      end

      def save_new_blob(blob)
        blob_size = blob.size
        current_part.save_new_blob(blob)

        self.saved_size += blob_size
        self.save
        check_completion_status
      end

      def current_part
        part = self.file_entity_oss_object_parts.last || self.file_entity_oss_object_parts.create
        part = self.file_entity_oss_object_parts.create if part.complete?
        part
      end

      def check_completion_status
        return if !complete?

        UploadFileEntityToAliyunOssResqueQueue.enqueue(self.id)
      end

      def upload_to_oss
        multipart_upload = OssManager::OSS_BUCKET.object(object_name).multipart_upload
        upload_id = multipart_upload.init
        
        part_infos = []
        self.file_entity_oss_object_parts.each_with_index do |part, index|
          part_infos << multipart_upload.upload(upload_id, index+1, File.open(part.part_path,'r'))
        end
        multipart_upload.complete(upload_id, part_infos)

        self.update_attributes!( :merged => true)
        self.file_entity_oss_object_parts.each{|part|part.destroy}
      end

      def complete?
        return true if self.saved_size == self.attach_file_size
        return false if self.saved_size < self.attach_file_size
        raise ObjectSizeOverflowError
      end

      def object_name
        self.attach.url.gsub(/\?.*/,"")
      end

      def http_url(style = :original)
        File.join("http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}", attach.url(style))
      end
      
    end
  end
end