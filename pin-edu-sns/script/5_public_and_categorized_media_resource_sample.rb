# -*- coding: utf-8 -*-
USERS = User.where('id > ?', 1).limit(8)

public_resources_path = File.join(ARGV[0], '/')

puts public_resources_path

def create_public_resource(path, category = nil)
  File.open(path,"r") do |f|
    pr = PublicResource.upload_by_user(USERS[rand 8], f)
    if !category.blank?
      pr.category = category
      pr.save
    end
    puts "PublicResource-#{pr.id} created!"
  end
end

def list_root_dir(path)
  Dir[File.join(path, "*")].each do |dir_or_file|
    p "process #{dir_or_file}"
    if File.file?(dir_or_file)
      create_public_resource(dir_or_file)
    else
      list_file_from_dir(dir_or_file)
    end
  end
end

def list_file_from_dir(path, category = nil)
  # 创建分类
  current_category = Category.create(:name=>File.basename(path))
  if category.blank?
    current_category.move_to_root
  else
    current_category.move_to_child_of(category)
  end

  # 遍历当前目录
  Dir[File.join(path,"*")].each do |dir_or_file|
    p "process #{dir_or_file}"
    if File.file?(dir_or_file)
      create_public_resource(dir_or_file, current_category)
    else
      list_file_from_dir(dir_or_file, current_category)
    end
  end
end

ActiveRecord::Base.transaction do

  # file
  file_dir = File.join(public_resources_path,"file")
  list_root_dir(file_dir)

  audio_dir = File.join(public_resources_path,"audio")
  list_root_dir(audio_dir)

  image_dir = File.join(public_resources_path,"image")
  list_root_dir(image_dir)
end
