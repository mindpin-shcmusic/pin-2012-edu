# -*- coding: utf-8 -*-
if User.count < 16
  puts '请先导入学生及老师示例'
  exit
end

path = ARGV[0]

pic_paths = Dir.entries(path).delete_if {|a| a == '.' || a== '..'}.map {|file_name|
  File.join path, file_name
}

puts pic_paths

USERS  = User.where('id > ?', 1).limit(8)
USER_IDS = USERS.map(&:id)

pic_paths.each {|path|
  pic  = File.open(path)
  user = USERS[rand 8]
  resource = MediaResource.put(user, File.join('/', File.basename(path)), pic)
  pic.close
  puts "**#{user.name}**上传了文件: #{File.basename pic.path}"
}

MediaResource.all.each do |resource|
  resource.share_to(:users => USER_IDS)
  resource.media_share_rule.build_share
  resource.share_public
  puts "已经分享#{resource.name}"
end
