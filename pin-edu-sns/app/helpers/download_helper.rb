module DownloadHelper

  def download_link(file_entity)
    download_id = get_download_id_by_file_entity_id(current_user,file_entity)
    "/download/#{download_id}"
  end

  # /download/#{str2}
  def get_download_id_by_file_entity_id(user,file_entity)
    str1 = Base64::encode64 "#{user.id},#{file_entity.id}"
    str2 = Base64::encode64 "#{user.id},#{str1}"
    str2.gsub("\n","")
  end

  def get_file_entity_id_by_download_id(user,download_id)
    str1 = Base64::decode64 download_id
    str2_arr = str1.split(',')
    return if str2_arr[0].to_i != user.id

    str3 = Base64::decode64 str2_arr[1]
    str3.split(',')[1]
  end
end