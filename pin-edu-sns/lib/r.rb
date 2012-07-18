class R
  PSUS_ASSET_SITE = 'http://dev.file.yinyue.edu'
  PSUS_UPLOAD_SITE = 'http://192.168.1.28'

  ATTACHED_BASE_DIR             = "#{Rails.root}/public"

  FILE_ENTITY_ATTACHED_PATH     = "#{ATTACHED_BASE_DIR}:url"
  FILE_ENTITY_ATTACHED_URL      = "/system/:attachment/:id/:style/:filename"

  SLICE_TEMP_FILE_ATTACHED_DIR  = "#{ATTACHED_BASE_DIR}/system/slice_temp_files/"
end