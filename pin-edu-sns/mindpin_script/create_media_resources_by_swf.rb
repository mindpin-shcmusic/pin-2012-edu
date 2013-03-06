current_user = User.find_by_name("zhugeliang")

Dir["/MINDPIN_MRS_DATA/swf/*"].each do |swf_path|
  file_name = File.basename(swf_path)
  resource_path = "/swf/#{file_name}"
  file_size = File.size(swf_path)
  
  file_entity = FileEntity.create(
    :attach_file_name => get_randstr_filename(file_name),
    :attach_content_type => file_content_type(file_name),
    :attach_file_size => file_size,
    :saved_size => file_size,
    :merged => true
  )

  file_entity.update_attributes(
    :attach_updated_at => file_entity.created_at
  )

  # 复制 文件到制定目录
  FileUtils.mkdir_p(File.dirname(file_entity.attach.path))
  FileUtils.cp(swf_path, file_entity.attach.path)

  mr = MediaResource.put_file_entity(current_user, resource_path, file_entity)

  p mr
end
p "success"

