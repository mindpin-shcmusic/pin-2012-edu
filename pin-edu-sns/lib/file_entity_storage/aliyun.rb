module FileEntityStorage
  module Aliyun
    def self.included(base)
      # 这个声明只是为了和 filesystem 接口统一，
      # 只负责 attach.url 的读取
      base.has_attached_file :attach,
                        :path => R::FILE_ENTITY_ATTACHED_PATH,
                        :url  => R::FILE_ENTITY_ATTACHED_URL

      base.has_many :aliyun_multipart_upload_parts, :order => 'part_num asc', :dependent => :destroy
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def save_first_blob(blob)
        save_new_blob(blob)
      end

      def save_new_blob(blob)
        multipart_upload = OssManager::OSS_BUCKET.object(object_name).multipart_upload
        part = self.aliyun_multipart_upload_parts.last
        md5 = Digest::MD5.file(blob.path).to_s


        if part.blank?
          upload_id = multipart_upload.init
          part_num = 1
        else
          upload_id = part.upload_id
          part_num = part.part_num+1
        end

        multipart_upload.upload(upload_id, part_num, blob)

        self.aliyun_multipart_upload_parts.create!(
          :upload_id => upload_id, :md5 => md5, :part_num => part_num)

        self.update_attributes!(
          :saved_size => self.saved_size+blob.size,
          :attach_updated_at => self.created_at
        )

        self.check_completion_status
      end

      def check_completion_status
        return if self.saved_size != self.attach_file_size

        part = self.aliyun_multipart_upload_parts.last
        upload_id = part.upload_id
        parts = self.aliyun_multipart_upload_parts.where(:upload_id => upload_id)
        part_infos = parts.map do |part|
          Oss::Object::MultipartUpload::PartInfo.new(part.part_num, part.md5)
        end

        multipart_upload = OssManager::OSS_BUCKET.object(object_name).multipart_upload
        multipart_upload.complete(upload_id, part_infos)

        self.update_attributes!( :merged => true )
        self.aliyun_multipart_upload_parts.clear
      end

      def object_name
        self.attach.url.gsub(/\?.*/,"")
      end
      
    end
  end
end