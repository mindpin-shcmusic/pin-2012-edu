class Base64Plus
  def self.encode64(str)
    encode_path = Base64::encode64(str).gsub("\n","")
    encode_path.gsub('/','-')
  end

  def self.decode64(str)
    str.gsub!('-','/')
    Base64::decode64(str)
  end
end