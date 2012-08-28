class FileEntityDownloadItem
  attr_reader :file_entity_id, :real_file_name
  def initialize(download_id)
    str1 = Base64Plus.decode64 download_id
    str2_arr = str1.split(',')

    str3 = Base64Plus.decode64 str2_arr[1]
    str3_arr = str3.split(',')
    str3_arr.shift
    @file_entity_id = str3_arr.shift
    @real_file_name = str3_arr.join(',')
  end
end