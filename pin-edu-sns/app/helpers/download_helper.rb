module DownloadHelper
  class DownloadItem
    attr_reader :file_entity_id, :real_file_name
    def initialize(download_id)
      str1 = Base64::decode64 download_id
      str2_arr = str1.split(',')

      str3 = Base64::decode64 str2_arr[1]
      str3_arr = str3.split(',')
      str3_arr.shift
      @file_entity_id = str3_arr.shift
      @real_file_name = str3_arr.join(',')
    end
  end

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
    str1 = Base64::encode64 "#{user.id},#{file_entity.id},#{real_file_name}"
    str2 = Base64::encode64 "#{user.id},#{str1}"
    str2.gsub("\n","")
  end

  def get_download_item_by_download_id(download_id)
    DownloadItem.new(download_id)
  end
end