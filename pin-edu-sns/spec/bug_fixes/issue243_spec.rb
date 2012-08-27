# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'issue243' do
  before do
    @ben7th = User.create(
      :name  => 'ben7th',
      :email => 'ben7th@sina.com',
      :password => '123456'
    )

    tmpfile = Tempfile.new('panda')
    tmpfile.write('hello world')

    @dir_media_resource = MediaResource.create(
      :name    => '我是目录',
      :is_dir  => true,
      :creator => @ben7th,
      :media_resources => [
        MediaResource.new(
          :name => '三只熊猫.jpg', 
          :is_dir => false,
          :creator => @ben7th,
          :file_entity => FileEntity.new(:attach => tmpfile)
        ),
        MediaResource.new(
          :name => 'abc', 
          :is_dir => true,
          :creator => @ben7th
        )
      ]
    )

    @file_media_resource_1 = MediaResource.create(
      :name => '三只狼.jpg', 
      :is_dir => false,
      :creator => @ben7th,
      :file_entity => FileEntity.new(:attach => tmpfile)
    )

    @file_media_resource_2 = MediaResource.create(
      :name => '三只熊猫.jpg', 
      :is_dir => false,
      :creator => @ben7th,
      :file_entity => FileEntity.new(:attach => tmpfile)
    )

    @dir_media_resource_1 = MediaResource.create(
      :name => 'def', 
      :is_dir => true,
      :creator => @ben7th
    )

    @dir_media_resource_2 = MediaResource.create(
      :name => 'abc', 
      :is_dir => true,
      :creator => @ben7th
    )
  end

  it '移动资源（文件、目录）时，目标位置有同名资源（文件、目录）时，应当都不允许移动' do
    @file_media_resource_1.move('/我是目录').should == true
    @file_media_resource_1.dir.should == @dir_media_resource

    @dir_media_resource_1.move('/我是目录').should == true
    @dir_media_resource_1.dir.should == @dir_media_resource

    @file_media_resource_2.move('/我是目录').should == false
    @file_media_resource_2.valid?.should == false
    @file_media_resource_2.errors[:dir_id].blank?.should == false

    @dir_media_resource_2.move('/我是目录').should == false
    @dir_media_resource_2.valid?.should == false
    @dir_media_resource_2.errors[:dir_id].blank?.should == false

    @file_media_resource_1.move('').should == true
    @file_media_resource_1.dir_id.should == 0
    @file_media_resource_1.move('/我是目录').should == true
    @file_media_resource_1.move(nil).should == true
    @file_media_resource_1.dir_id.should == 0
    @file_media_resource_1.move('/我是目录').should == true
    @file_media_resource_1.move('/').should == true
    @file_media_resource_1.dir_id.should == 0
  end
end