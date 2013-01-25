class CourseWare < ActiveRecord::Base
  belongs_to :chapter
  has_one    :media_resource

  validates :title, :chapter, :media_resource, :presence => true
end
