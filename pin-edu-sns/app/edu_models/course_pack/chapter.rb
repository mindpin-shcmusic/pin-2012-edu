# -*- coding: utf-8 -*-
class Chapter < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :creator, :class_name => 'User'
  has_many :course_wares

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

end
