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
end
