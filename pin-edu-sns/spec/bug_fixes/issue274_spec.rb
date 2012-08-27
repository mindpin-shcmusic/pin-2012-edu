# -*- coding: no-conversion -*-
require 'spec_helper'

describe 'issue274' do
  before do
    @ben7th = User.create(
      :name  => 'ben7th',
      :email => 'ben7th@sina.com',
      :password => '123456'
    )

    @dir_media_resource = MediaResource.create(
      :name    => '我是目录',
      :is_dir  => true,
      :creator => @ben7th,
      :media_resources => [
        MediaResource.new(
          :name => '子目录',
          :is_dir => true,
          :creator => @ben7th
        )
      ]
    )

  end

  it '目前在个人文件夹上传文件时，如果已经有同名文件，会被直接覆盖。这样有时候是不靠谱的。' do
    tmpfile = Tempfile.new('panda')
    tmpfile.write('hello world')

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc'
    abc.path.should == '/我是目录/abc'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc(1)'
    abc.path.should == '/我是目录/abc(1)'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc(2)'
    abc.path.should == '/我是目录/abc(2)'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc'
    abc.path.should == '/abc'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc(1)'
    abc.path.should == '/abc(1)'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
    abc = MediaResource.last
    abc.name.should == 'abc(2)'
    abc.path.should == '/abc(2)'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
    abc = MediaResource.last
    abc.name.should == 'a.jpg'
    abc.path.should == '/我是目录/子目录/a.jpg'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
    abc = MediaResource.last
    abc.name.should == 'a(1).jpg'
    abc.path.should == '/我是目录/子目录/a(1).jpg'

    file_entity = FileEntity.create(:attach => tmpfile)
    MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
    abc = MediaResource.last
    abc.name.should == 'a(2).jpg'
    abc.path.should == '/我是目录/子目录/a(2).jpg'

    file_entity = FileEntity.create(:attach => tmpfile)
    a = MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
    abc = MediaResource.last
    abc.name.should == 'a(3).jpg'
    abc.path.should == '/我是目录/子目录/a(3).jpg'
    a.should == abc
  end
end