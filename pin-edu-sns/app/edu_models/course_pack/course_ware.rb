class CourseWare < ActiveRecord::Base
  has_one    :media_resource
  belongs_to :chapter
  belongs_to :creator,
             :class_name => 'User',
             :foreign_key => 'creator_id'

  validates :title, :chapter, :media_resource, :creator, :presence => true
end
