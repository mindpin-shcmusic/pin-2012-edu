module FileShowHelper
  def file_show_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64Plus.encode64(media_resource.path)
    "/file_show/#{encode_path}"
  end

  def file_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64Plus.encode64(media_resource.path)
    "/file/#{encode_path}"
  end

  def media_share_link(media_resource)
    return "" if media_resource.blank?
    encode_path = Base64Plus.encode64(media_resource.path)
    "/media_shares/users/#{media_resource.creator_id}/#{encode_path}"
  end
end