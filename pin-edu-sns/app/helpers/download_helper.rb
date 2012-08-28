module DownloadHelper
  def download_link(file_entity,real_file_name)
    return if file_entity.blank?
    raise "#{file_entity} 不是 file_entity 实例" if !file_entity.is_a?(FileEntity)
    download_id = get_download_id_by_file_entity_id(current_user,file_entity,real_file_name)
    "/download/#{download_id}"
  end

  def media_resource_download_link(media_resource)
    return if media_resource.blank?
    download_link(media_resource.file_entity,media_resource.name)
  end

  # /download/#{str2}
  def get_download_id_by_file_entity_id(user,file_entity,real_file_name)
    str1 = Base64Plus.encode64 "#{user.id},#{file_entity.id},#{real_file_name}"
    str2 = Base64Plus.encode64 "#{user.id},#{str1}"
    str2
  end
end