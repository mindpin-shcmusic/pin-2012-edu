class Chapter < ActiveRecord::Base
  belongs_to :teaching_plan
  belongs_to :creator, :class_name => 'User'
  has_many :course_wares

  validates :title, :presence => true
  validates :teaching_plan, :presence => true
  validates :creator, :presence => true

  before_validation :set_chapter_title, :on => :create
  def set_chapter_title
    count = self.teaching_plan.chapters.count
    self.title = "第 #{count+1} 章节"
  end
end
