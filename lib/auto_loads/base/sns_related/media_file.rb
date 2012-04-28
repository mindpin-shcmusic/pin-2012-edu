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
    :video == self.content_kind
  end
  
  def swf_player_url
    tmps = "#{self.file.path}.flv".split("/")
    tmps.shift

    flv_url = File.join("http://dev.file.yinyue.edu",tmps*'/')
    "http://dev.sns.yinyue.edu/player.swf?type=http&file=#{flv_url}"
  end
  
  def encode_success?
    SUCCESS == self.video_encode_status
  end
  
  CONTENT_TYPES = {
    :video    => [
        'avi', 'rm',  'rmvb', 'mp4', 
        'ogv', 'm4v', 'flv', 'mpeg',
        '3gp'
      ].map{|x| file_content_type(x)}.uniq,
    :audio    => [
        'mp3', 'wma', 'm4a',  'wav', 
        'ogg'
      ].map{|x| file_content_type(x)}.uniq,
    :image    => [
        'jpg', 'jpeg', 'bmp', 'png', 
        'png', 'svg',  'tif', 'gif'
      ].map{|x| file_content_type(x)}.uniq,
    :document => [
        'pdf', 'xls', 'doc', 'ppt'
      ].map{|x| file_content_type(x)}.uniq
  }

  def content_kind
    case self.file_content_type
    when *CONTENT_TYPES[:video]
      :video
    when *CONTENT_TYPES[:audio]
      :audio
    when *CONTENT_TYPES[:image]
      :image
    when *CONTENT_TYPES[:document]
      :document
    end
  end

  scope :with_kind, lambda {|kind|

    if kind.blank?
      return where('1 = 1')
    end

    if [:video, :audio, :image, :document].include? kind.to_sym
      types = CONTENT_TYPES[kind.to_sym]
      count = types.length
      condition_str = ['?']*count*','

      return where("file_content_type IN (#{condition_str})", *types)
    end

    if :other == kind.to_sym
      all = CONTENT_TYPES[:video] + 
            CONTENT_TYPES[:audio] + 
            CONTENT_TYPES[:image] + 
            CONTENT_TYPES[:document]

      count = all.length
      condition_str = ['?']*count*','

      return where("file_content_type NOT IN (#{condition_str})", *all)
    end
  }

  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :media_files, :foreign_key => :creator_id
    end
  end
end
