# -*- coding: utf-8 -*-
require 'script/helper'
require 'script/pack1'
require 'script/pack2'
require 'script/pack3'
require 'script/pack4'
require 'script/pack5'
require 'script/pack6'

case ARGV[0]
when 'clear-pack-records'
  puts '删除脚本运行记录....'
  `rm -rf tmp/scripts`
  exit
when 'clear-db'
  puts '清空数据库....'
  `rake db:drop && rake db:create && rake db:migrate > /dev/null`
  exit
end

prompt = '
==============================================

            请选择要导入的数据包

==============================================

1. 学生、教师、管理员等用户相关

2. 课程、班级、任课老师、上课学生以及学生分班

3. 作业、通知、问答

4. 媒体资源、公共资源

5. 课程资源

6. 导师双向选择

==============================================

'

puts prompt

def get_choice
  puts '请选择要导入的选项(1-6):'
  choice = gets.chomp.to_i

  return choice if (1..6).to_a.include? choice
  get_choice
end

def run
  `mkdir -p tmp/scripts`
  choice = get_choice
  puts "准备运行选项-#{choice}......\n\n"
  send "pack#{choice}"
end

run
