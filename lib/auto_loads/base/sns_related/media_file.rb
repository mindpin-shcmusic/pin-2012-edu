require "uuidtools"
class MediaFile < BuildDatabaseAbstract
  belongs_to :category
  belongs_to :creator,:class_name=>"User",:foreign_key=>"creator_id"
  PLACE_OSS = "oss"
  PLACE_EDU = "edu"
  
  ENCODING = "ENCODING"
  SUCCESS = "SUCCESS"
  FAILURE = "FAILURE"
  
  validates :place, :presence => true, :inclusion => [PLACE_OSS,PLACE_EDU]
  validates :creator, :uuid,:file_file_name, :presence => true
  validate :category_should_be_leafy_or_nil
  
  has_attached_file :file,
      :storage =>  :oss,
      :path => lambda { |attachment| attachment.instance._file_path },
      :url  => lambda { |attachment| attachment.instance._file_url }

  default_scope order("created_at DESC")

  def is_video?
    VideoUtil.is_video?(File.basename(self.file_file_name))
  end
  
  def flv_path
    if is_video?
      origin_path = self.file.path
      "#{origin_path}.flv"
    end
  end
  
  def flv_url
    tmps = flv_path.split("/")
    tmps.shift
#    "http://dev.file.psu.edu/#{tmps*"\/"}"
    "http://dev.file.yinyue.edu/player.swf?type=http&file=#{tmps*"\/"}"
  end
  
  def encode_success?
    self.video_encode_status == SUCCESS
  end
  
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

private

  def category_should_be_leafy_or_nil
    unless  category.nil? || category.leaf?
      errors.add(:category, "必须保存在叶子分类下或者暂不分类")
    end
  end
end
