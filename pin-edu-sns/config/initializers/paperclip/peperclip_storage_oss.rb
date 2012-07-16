module Paperclip
  module Storage
    module Oss
      def self.extended base
#        p "oss self.extended"
      end

      def meta(style_name = default_style)
        if !original_filename.blank?
          OssManager.get_file_meta(path(style_name))
        else
          {}
        end
      end

      def exists?(style_name = default_style)
        if !original_filename.blank?
          OssManager.file_exists?(path(style_name))
        else
          false
        end
      rescue
        false
      end

      def to_file style_name = default_style
        return @queued_for_write[style_name] if @queued_for_write[style_name]
         OssManager.get_file(path(style_name))
      end

      def flush_writes
        @queued_for_write.each do |style, file|
          log("saving #{path(style)}")
          OssManager.upload_file(file,path(style),content_type)
        end
        
        after_flush_writes # allows attachment to clean up temp files

        @queued_for_write = {}
      end

      def flush_deletes
        @queued_for_delete.each do |path|
          log("deleting #{path}")
          begin
            OssManager.delete_file(path)
          rescue ::Oss::ResponseError => ex
            # 忽略吧...
          end
        end
        @queued_for_delete = []
      end
    end

  end
end
