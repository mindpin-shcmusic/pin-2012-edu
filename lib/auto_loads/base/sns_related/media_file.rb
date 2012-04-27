class MediaFile < BuildDatabaseAbstract

  PLACE_OSS = "oss"
  PLACE_EDU = "edu"
  
  ENCODING = "ENCODING"
  SUCCESS  = "SUCCESS"
  FAILURE  = "FAILURE"
  
  belongs_to :category
  belongs_to :creator, :class_name=>"User", :foreign_key=>"creator_id"

  default_scope order("created_at DESC")
  
  validates :place, :presence => true, :inclusion => [PLACE_OSS,PLACE_EDU]
  validates :creator,:file_file_name, :presence => true

  validate  :category_should_be_leafy_or_nil
  def category_should_be_leafy_or_nil
    unless  category.nil? || category.leaf?
      errors.add(:category, "必须保存在叶子分类下或者暂不分类")
    end
  end

  # -----------------------  

  has_attached_file :file,
    :styles => {
      :large => '460x340#',
      :small => '220x140#'
    },
    :storage =>  :oss,
    :path => lambda { |attachment| attachment.instance._attachment_file_path },
    :url  => lambda { |attachment| attachment.instance._attachment_file_url }

  def _attachment_file_url
    if place == PLACE_OSS
      "http://storage.aliyun.com/#{OssManager::CONFIG["bucket"]}/:class/:attachment/#{self.id}/:style/:basename.:extension"
    else
      "http://dev.file.yinyue.edu/:class/:attachment/#{self.id}/:style/:basename.:extension"
    end
  end
  
  def _attachment_file_path
    "/:class/:attachment/#{self.id}/:style/:basename.:extension"
  end

  # ----------------

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
    "http://dev.file.yinyue.edu/player.swf?type=http&file=#{tmps*"\/"}"
  end
  
  def encode_success?
    self.video_encode_status == SUCCESS
  end
  
  CONTENT_TYPES = {
    :videos    => ['avi', 'rm', 'rmvb', 'mp4', 'ogv', 'm4v', 'flv', 'mpeg'].map{|x| file_content_type(x)},
    :audios    => ['mp3', 'wma', 'm4a', 'wav', 'ogg'].map{|x| file_content_type(x)},
    :images    => ['jpeg', 'x-bmp', 'png', 'png', 'svg'].map{|x| file_content_type(x)},
    :documents => ['xls', 'pdf', 'doc', 'ppt'].map{|x| file_content_type(x)}
  }

  def content_kind
    case self.file_content_type
    when *CONTENT_TYPES[:videos]
      :video
    when *CONTENT_TYPES[:audios]
      :audio
    when *CONTENT_TYPES[:images]
      :image
    when *CONTENT_TYPES[:documents]
      :document
    end
  end

  [:videos, :audios, :images, :documents].each do |kind|
    types = CONTENT_TYPES[kind]
    count = types.length

    condition_str = ['?']*count*','

    scope kind, where("file_content_type IN (#{condition_str})", *types)
  end

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :media_files, :foreign_key => :creator_id
    end
  end
end
