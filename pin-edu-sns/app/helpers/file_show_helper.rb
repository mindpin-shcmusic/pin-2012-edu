module FileShowHelper
  def file_show_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64::encode64(media_resource.path).gsub("\n","")
    "/file_show/#{encode_path}"
  end

  def get_media_resource_path_by_encode_path(encode_path)
    Base64::decode64(encode_path)
  end

  def file_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64::encode64(media_resource.path).gsub("\n","")
    "/file/#{encode_path}"
  end

  def media_share_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64::encode64(media_resource.path).gsub("\n","")
    "/media_shares/users/#{media_resource.creator_id}/#{encode_path}"
  end
end