current_user = User.find_by_name("teacher1")
Dir["/web/kecheng/*"].each do |flv_path|
  file_name = File.basename(flv_path)
  resource_path = "/课件资源/#{file_name}"
  file_size = File.size(flv_path)
  


  file_entity = FileEntity.create(
    :attach_file_name => get_randstr_filename(file_name),
    :attach_content_type => file_content_type(file_name),
    :attach_file_size => file_size,
    :saved_size => file_size,
    :merged => true,
    :video_encode_status => FileEntity::EncodeStatus::SUCCESS
  )

  file_entity.update_attributes(
    :attach_updated_at => file_entity.created_at
  )

  # 复制 文件到制定目录
  FileUtils.mkdir_p(File.dirname(file_entity.attach.path))
  FileUtils.cp(flv_path, file_entity.attach.path)

  origin_file_path = file_entity.attach.path
  # 生成 flv 文件
  FileUtils.cp(origin_file_path, file_entity.attach_flv_path)
  # 生成缩略图
  VideoUtil.screenshot(origin_file_path, File.dirname(origin_file_path))

  mr = MediaResource.put_file_entity(current_user, resource_path, file_entity)

  p mr
end
p "success"





