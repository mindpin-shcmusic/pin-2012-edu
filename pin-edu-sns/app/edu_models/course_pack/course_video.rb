class CourseVideo < ActiveRecord::Base
  belongs_to :course
  belongs_to :file_entity

  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  validates :course,
            :presence => true

  validates :file_entity_id,
            :presence   => true,
            :uniqueness => {:scope => :course_id}

  default_scope order('created_at DESC')

  include Comment::CommentableMethods

  module UserMethods
    def self.included(base)
      base.has_many :course_images, :foreign_key => :creator_id
    end
  end

end
