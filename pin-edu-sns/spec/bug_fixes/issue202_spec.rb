# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'issue202' do
  before do
    @ben7th = User.create(
      :name  => 'ben7th',
      :email => 'ben7th@sina.com',
      :password => '123456'
    )

    @dir_media_resource = MediaResource.create(
      :name    => '我是目录',
      :is_dir  => true,
      :creator => @ben7th
    )

    tmpfile = Tempfile.new('panda')
    tmpfile.write('hello world')
    @file_media_resource_1 = MediaResource.new(
      :name => '三只熊猫.jpg', 
      :is_dir => false,
      :creator => @ben7th,
      :file_entity => FileEntity.new(:attach => tmpfile)
    )

    @file_media_resource_2 = MediaResource.new(
      :name => '三只狼.jpg', 
      :is_dir => false,
      :creator => @ben7th,
      :file_entity => FileEntity.new(:attach => tmpfile)
    )
  end

  it '个人资源目录 dir_id 字段没有增加校验' do
    @file_media_resource_1.dir_id = @dir_media_resource.id
    @file_media_resource_1.valid?.should == true

    @file_media_resource_1.dir_id = @file_media_resource_2.id
    @file_media_resource_1.valid?.should == false
    @file_media_resource_1.errors[:dir_id].blank?.should == false

    @file_media_resource_1.dir_id = -1
    @file_media_resource_1.valid?.should == false
    @file_media_resource_1.errors[:dir_id].blank?.should == false    
  end
end