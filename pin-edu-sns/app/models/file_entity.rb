# -*- coding: utf-8 -*-
class FileEntity < ActiveRecord::Base
  include FileEntityStorage::Filesystem

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

  before_validation(:on => :create) do |file_entity|
    file_entity.saved_size = 0
  end

  def self.create_by_params(file_name,file_size)
    self.create(
      :attach_file_name => get_randstr_filename(file_name),
      :attach_content_type => file_content_type(file_name),
      :attach_file_size => file_size,
      :merged => false
    )
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

    # 获取资源种类
  def content_kind
    self.class.content_kind(self.attach_content_type)
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


end
