require "uuidtools"
class MediaFile < BuildDatabaseAbstract
  belongs_to :category
  belongs_to :creator,:class_name=>"User",:foreign_key=>"creator_id"
  PLACE_OSS = "oss"
  PLACE_EDU = "edu"
  
  validates :place, :presence => true, :inclusion => [PLACE_OSS,PLACE_EDU]
  validates :creator, :uuid, :presence => true
  
  has_attached_file :file,
      :storage =>  :oss,
      :path => lambda { |attachment| attachment.instance._file_path },
      :url  => lambda { |attachment| attachment.instance._file_url }
  
  def _file_url
    if place == PLACE_OSS
      "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/#{self.uuid}/:style/:basename.:extension"
    else
      "http://dev.file.yinyue.edu/:class/:attachment/#{self.uuid}/:style/:basename.:extension"
    end
  end
  
  def _file_path
    "/:class/:attachment/#{self.uuid}/:style/:basename.:extension"
  end
  
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :media_files, :foreign_key => :creator_id
    end
  end
end
