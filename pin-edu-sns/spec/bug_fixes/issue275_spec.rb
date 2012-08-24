# -*- coding: no-conversion -*-
require 'spec_helper'

describe 'issue275' do
  it '“/299925.jpg/阿” 进行 base64编码后，最后一位是 “/” 这样会造成服务端解析path 时，因为得不到最后的 “/” 而出现错误' do
    origin_path = '/299925.jpg/阿'

    encode_path = Base64Plus.encode64('/299925.jpg/阿')
    encode_path.include?('/').should == false

    Base64Plus.decode64(encode_path).should == origin_path
  end
end