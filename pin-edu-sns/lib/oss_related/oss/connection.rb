module Oss
  class Connection
    include Parser

    def initialize(options)
      @access_key_id = options.delete :access_key_id
      @secret_access_key = options.delete :secret_access_key
    end

    def request(method, options)
      path = options.delete :path
      headers = options.delete(:headers) || {}   
      body = options.delete(:body) || nil
      method = method.to_s.upcase

      head_hash = Signature.generate(access_key_id, :method => method, :path => path, :headers => headers)

      Net::HTTP.start('storage.aliyun.com') do |http|
        r = http.send_request( method.to_s.upcase, path, body, headers)
        handle_response(r)
      end
    end

    def handle_response(response)
      case response.code.to_i
      when 200...300
        p "hadnle resopnse"
        p response.code.to_i
        p response.body
        return response
      else
        code,message = parse_error(response.body)
        Error.exception(code).new(message, response)
      end
    end

  end
end