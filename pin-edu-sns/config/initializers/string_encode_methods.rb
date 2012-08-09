require 'iconv'
class String
  def utf8_to_gb2312
    encode_convert(self,"gb2312","UTF-8")
  end

  def gb2312_to_utf8
    encode_convert(self,"UTF-8","gb2312")
  end

  def utf8?
    utf8_arr = self.unpack('U*')
    true if utf8_arr && utf8_arr.size > 0
  rescue
    false
  end

  private
    
  def encode_convert(s, to, from)
    converter = Iconv.new(to, from)
    converter.iconv(s)
  rescue Exception=>ex
    p ex.message
    puts ex.backtrace*"\n"
    s
  end
end
