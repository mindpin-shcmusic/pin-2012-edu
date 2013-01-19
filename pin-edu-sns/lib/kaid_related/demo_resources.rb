# -*- coding: utf-8 -*-
DemoResourceNames = ['面向对象程序设计.ppt', '文件与数据流.ppt']

DemoResources = DemoResourceNames.map do |name|
  OpenStruct.new(:name       => name,
                 :created_at => 4.days.ago,
                 :is_dir     => false,
                 :id         => DemoResourceNames.index(name) + 1,
                 :path       => 'javascript:;')
end
