module Oss
  class Object
    attr_reader :service, :bucket, :name, :path
    def initialize(bucket, name)
      @bucket = bucket
      @service = bucket.service
      @connection = @service.connection
      @name = name
      @path = File.join("/", @bucket.name, @name)
    end

    def upload(file, content_type)
      body = IO.read(file.path)
      md5 = Digest::MD5.hexdigest(body)
      content_length = body.length

      @connection.request(:put, :path => @path, :body => body,
        :headers => {  :md5 => md5, :content_type => content_type })
    end

    def delete
      @connection.request(:delete, :path => @path)
    end

    def get_body
      @connection.request(:get, :path => @path).body
    end

    def get_file
      body = get_body
      return if body.blank?
    
      extname  = File.extname(@name)
      basename = File.basename(@name, extname)
      file = Tempfile.new([basename, extname])
      file.binmode
      file.write(body)
      file.rewind
      return file
    end

    def meta
      response = @connection.request(:head, :path => @path).body

      return {
        :content_type => response["Content-Type"],
        :content_length => response["Content-Length"].to_i,
        :file_name => File.basename(save_path)
      }
    end

    def exists?
      meta
      true
    rescue
      false
    end

    def multipart_upload
      MultipartUpload.new(self)
    end

    class MultipartUpload
      def initialize(object)
        @object = object
        @bucket = object.bucket
        @connection = @bucket.service.connection
      end

      def init
        path = "#{@object.path}?uploads"

        response = @connection.request(:post, :path => path).body
        return Nokogiri::XML(response.body).css("InitiateMultipartUploadResult UploadId").text()
      end

      def upload(upload_id, part_num, part)
        path = "#{@object.path}?partNumber=#{part_num}?uploadId=#{upload_id}"

        body = IO.read(part.path)
        md5 = Digest::MD5.hexdigest(body)
        response = @connection.request(:put, :path => path, :body => body)
        raise Error::ResponseError.new(nil, response) if response['ETag'] != md5
        return PartInfo.new(part_num, md5)
      end

      def complete(upload_id, part_infos)
        path = "#{@object.path}?uploadId=#{upload_id}"

        parts_str = part_infos.map.each do |part_info|
          %`
            <Part>
              <PartNumber>#{part_info.part_number}</PartNumber>
              <ETag>#{part_info.etag}</ETag>
            </Part>
          `
        end.join("")

        body = %`
          <CompleteMultipartUpload>
            #{parts_str}
          </CompleteMultipartUpload>
        `

        @connection.request(:post, :path => path, :body => body)
      end

      def abort(upload_id)
        path = "#{@object.path}?uploadId=#{upload_id}"
        @connection.request(:delete, :path => path)
      end

      class PartInfo
        attr_reader :part_number, :etag
        def initialize(part_number, etag)
          @part_number = part_number
          @etag = etag
        end
      end
    end

  end
end