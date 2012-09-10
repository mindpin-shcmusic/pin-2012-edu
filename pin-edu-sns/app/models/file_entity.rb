# -*- coding: utf-8 -*-
class FileEntity < ActiveRecord::Base

  CONTENT_TYPES = {
    :video    => [
        'avi', 'rm',  'rmvb', 'mp4', 
        'ogv', 'm4v', 'flv', 'mpeg',
        '3gp'
      ].map{|x| file_content_type(x)}.uniq - ['application/octet-stream'],
    :audio    => [
        'mp3', 'wma', 'm4a',  'wav', 
        'ogg'
      ].map{|x| file_content_type(x)}.uniq,
    :image    => [
        'jpg', 'jpeg', 'bmp', 'png', 
        'png', 'svg',  'tif', 'gif'
      ].map{|x| file_content_type(x)}.uniq,
    :document => [
        'pdf', 'xls', 'doc', 'ppt', 
        'txt'
      ].map{|x| file_content_type(x)}.uniq
  }

  has_many :media_resources
  has_many :homework_student_uploads
  has_many :homework_teacher_attachment

  has_attached_file :attach,
                    :styles => lambda {|attach|
                      attach.instance.is_image? ? {:large => '460x340#', :small => '220x140#'}  : {}
                    },
                    :path => R::FILE_ENTITY_ATTACHED_PATH,
                    :url  => R::FILE_ENTITY_ATTACHED_URL

  before_validation(:on => :create) do |file_entity|
    file_entity.saved_size = 0
  end

  def self.get_or_greate_by_file_md5(file)
    md5 = Digest::MD5.file(file).to_s

    entity = self.find_by_md5 md5
    return entity if entity

    return FileEntity.create :attach => file,
                             :md5 => md5
  end

  ##################
  class EncodeStatus
    ENCODEING = "ENCODING"
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

  # 获取资源种类
  def content_kind
    self.class.content_kind(self.attach_content_type)
  end

  def self.content_kind(type)
    case type
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

  def video_encoding?
    is_video? && video_encode_status == FileEntity::EncodeStatus::ENCODEING
  end

  def video_encode_success?
    is_video? && video_encode_status == FileEntity::EncodeStatus::SUCCESS
  end

  def video_encode_failure?
    is_video? && video_encode_status == FileEntity::EncodeStatus::FAILURE
  end

  def into_video_encode_queue
    return if !self.is_video?
    return if self.video_encode_success?

    self.video_encode_status = FileEntity::EncodeStatus::ENCODEING
    self.save
    FileEntityVideoEncodeResqueQueue.enqueue(self.id)
  end

  def self.create_by_params(file_name,file_size)
    self.create(
      :attach_file_name => get_randstr_filename(file_name),
      :attach_content_type => file_content_type(file_name),
      :attach_file_size => file_size,
      :merged => false
    )
  end

  def save_first_blob(blob)
    FileUtils.mkdir_p(File.dirname(self.attach.path))
    FileUtils.mv(blob.path,self.attach.path)

    self.update_attributes(
      :saved_size => blob.size,
      :attach_updated_at => self.created_at
    )
    self.check_completion_status
  end

  def save_new_blob(file_blob)
    file_blob_size = file_blob.size
    # `cat '#{file_blob.path}' >> '#{file_path}'`
    File.open(self.attach.path,"a") do |src_f|
      File.open(file_blob.path,'r') do |f|
        src_f << f.read
      end
    end

    self.saved_size += file_blob_size
    self.save
    self.check_completion_status
  end

  def check_completion_status
    return if self.saved_size != self.attach_file_size

    self.update_attributes( :merged => true )
    # 如果 文件是图片，生成 all styles 图片
    self.attach.reprocess!
    if self.is_video?
      self.into_video_encode_queue
    end
  end
end
