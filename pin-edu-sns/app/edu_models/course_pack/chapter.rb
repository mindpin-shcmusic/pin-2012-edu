class Chapter < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :creator, :class_name => 'User'
  has_many :course_wares

  validates :title, :desc, :teaching_plan, :creator, :presence => true

  before_validation :set_chapter_title_desc, :on => :create
  def set_chapter_title_desc
    count = self.teaching_plan.chapters.count
    self.title = "第 #{count+1} 章节"
    self.desc = "第 #{count+1} 章节描述"
  end
end
