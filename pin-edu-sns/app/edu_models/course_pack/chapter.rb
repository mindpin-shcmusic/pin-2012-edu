# -*- coding: utf-8 -*-
class Chapter < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :creator, :class_name => 'User'
  has_many :course_wares

  validates :title, :presence => true
  validates :teaching_plan, :presence => true
  validates :creator, :presence => true

  before_validation :set_chapter_title, :on => :create
  def set_chapter_title
    self.title = self.generate_title
  end

  def generate_title
    last_chapter = self.teaching_plan.chapters.last
    num = last_chapter ? last_chapter.title.chars.to_a[2].to_i + 1 : 1
    "第 #{num} 章节"
  end

end
