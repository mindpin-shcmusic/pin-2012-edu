# -*- coding: utf-8 -*-
$script_record_dir = 'tmp/scripts/'

def touch_pack_record(number)
  `touch #{$script_record_dir}#{number}`
end

def is_script_record_exist?(number)
  File.exists? "#{$script_record_dir}#{number}"
end

def depends_on(numbers)
  numbers.each do |number|
    return if is_script_record_exist?(number)
    puts "执行依赖选项-#{number}......"
    require "script/pack#{number}"
    send "pack#{number}"
  end
end
