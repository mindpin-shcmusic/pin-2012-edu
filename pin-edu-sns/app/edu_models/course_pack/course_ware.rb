# -*- coding: utf-8 -*-
class CourseWare < ActiveRecord::Base
  belongs_to :media_resource
  belongs_to :chapter
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  validates :title, :desc, :chapter, :creator, :presence => true

  before_validation :set_course_ware_title_desc, :on => :create

  def set_course_ware_title_desc
    count = self.chapter.course_wares.count
    self.title = "课件标题-#{count+1}"
    self.desc = "课件描述-#{count+1}"
  end

  def upload_file(file_entity,file_name,user)
    chapter = self.chapter
    teaching_plan = chapter.teaching_plan
    course = teaching_plan.course

    resource_path = File.join("/",course.name,teaching_plan.title,chapter.title,file_name)
    media_resource = MediaResource.put_file_entity(user, resource_path, file_entity)
    self.media_resource = media_resource
    self.save
  end

  def link_file(media_resource)
    self.media_resource = media_resource
    self.save
  end

  def content_kind
    media_resource && self.file_entity.content_kind
  end

  def url
    media_resource && self.file_entity.attach_flv_url
  end

  def video_encode_status
    media_resource && self.file_entity.video_encode_status
  end

  def file_entity
    media_resource && self.media_resource.file_entity
  end

end
