# -*- coding: utf-8 -*-
if User.count < 16
  puts '请先导入学生及老师示例'
  exit
end

pics_path = ARGV[0][-1] == '/' ? ARGV[0] : ARGV[0] + '/'
pic_paths = Dir.entries(pics_path).map {|path|
  File.join pics_path, path
}[2..-1]

USERS  = User.all.shuffle[0, 16]
USER_IDS = User.all.map(&:id).shuffle

PATHS = ['this is a folder', 'this is another folder', 'this is yet another folder'].map {|word|
  word.split(' ').reduce([]) {|parent_path, folder|
    path = [parent_path[1], folder].join('/')
    [parent_path, path]
  }.flatten
}.flatten.uniq

def rand_path(file)
  File.join PATHS[rand PATHS.count - 1], File.basename(file.path)
end

puts PATHS
puts pic_paths

ActiveRecord::Base.transaction do
  pic_paths.each {|path|
    pic  = File.open(path)
    user = USERS[rand 15]
    resource = MediaResource.put(user, rand_path(pic), pic)
    pic.close
    puts "**#{user.name}**上传了文件: #{File.basename pic.path}"
  }

  MediaResource.all.each do |resource|
    receiver_ids = USER_IDS[rand(USER_IDS.count - 1), rand(64)]
    resource.share_to(:users => receiver_ids)
    resource.media_share_rule.build_share
    resource.share_public if resource.id / 4 == 0
    puts "已经分享#{resource.name}"
  end
end

puts MediaResource.count
puts MediaShare.count
