class FileEntity < ActiveRecord::Base
  has_many :media_resources

  has_attached_file :attach,
                    :styles => {
                      :large => '460x340#',
                      :small => '220x140#'
                    },
                    :path => R::FILE_ENTITY_ATTACHED_PATH,
                    :url  => R::FILE_ENTITY_ATTACHED_URL

  def self.get_or_greate_by_file_md5(file)
    md5 = Digest::MD5.file(file).to_s

    entity = self.find_by_md5 md5
    return entity if entity

    return FileEntity.create :attach => file,
                             :md5 => md5
  end

  ##################
  class EncodeStatus
    SUCCESS  = "SUCCESS"
    FAILURE  = "FAILURE"
  end

  def attach_flv_path
    "#{self.attach.path}.flv"
  end

  def attach_flv_url
    self.attach.url.gsub(/\?.*/,".flv")
  end

  def is_video?
    :video == self.content_kind
  end

  def is_audio?
    :audio == self.content_kind
  end

  def is_image?
    :image == self.content_kind
  end

  def content_kind
    content_type_kind(self.attach_content_type)
  end
end
