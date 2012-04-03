require "uuidtools"
class MediaFile < BuildDatabaseAbstract
  belongs_to :category
  belongs_to :creator,:class_name=>"User",:foreign_key=>"creator_id"
  PLACE_OSS = "oss"
  PLACE_EDU = "edu"
  
  validates :place, :presence => true, :inclusion => [PLACE_OSS,PLACE_EDU]
  validates :creator, :uuid, :presence => true
  validate :category_should_be_leafy_or_nil
  
  has_attached_file :file,
      :storage =>  :oss,
      :path => lambda { |attachment| attachment.instance._file_path },
      :url  => lambda { |attachment| attachment.instance._file_url }

  default_scope order("created_at DESC")

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
    if (!category.leaf?)
      errors.add(:category, "必须保存在叶子分类下")
    end
  end
end
