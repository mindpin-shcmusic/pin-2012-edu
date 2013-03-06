# -*- coding: utf-8 -*-
class Chapter < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :creator, :class_name => 'User'
  has_many :course_wares
  has_many :homeworks

  validates :title, :desc, :teaching_plan, :creator, :presence => true

  before_validation :set_chapter_title, :on => :create
  def set_chapter_title
    num = self.generate_chapter_num
    self.title = "第 #{num} 章节"
    self.desc = "第 #{num} 章节描述"
  end

  def generate_chapter_num
    last_chapter = self.teaching_plan.chapters.last
    last_chapter ? last_chapter.title.chars.to_a[2].to_i + 1 : 1
  end

  def course
    self.teaching_plan.course
  end

  def cover_url
    image_url = ""

    course_ware = self.course_wares.first
    if !course_ware.blank?
      url = course_ware.screenshot_urls.first  
      if !url.blank?
        image_url = url
      end
    end

    image_url
  end

end
