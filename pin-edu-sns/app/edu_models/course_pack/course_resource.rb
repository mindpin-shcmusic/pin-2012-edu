class CourseResource < ActiveRecord::Base
  KIND_IMAGE = 'IMAGE'
  KIND_AUDIO = 'AUDIO'
  KIND_COURSEWARE = 'COURSEWARE'

  belongs_to :course
  belongs_to :file_entity
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  validates :course, :presence => true
  validates :creator, :presence => true
  validates :file_entity_id, :presence => true,
    :uniqueness => {:scope => :course_id}
  validates :kind, :presence => true,
    :inclusion => [KIND_IMAGE, KIND_AUDIO, KIND_COURSEWARE]

  default_scope order('created_at DESC')
  scope :with_kind, lambda { |kind| {:conditions => {:kind=>kind}} }

  include Comment::CommentableMethods

end
