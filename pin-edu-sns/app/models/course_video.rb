class CourseVideo < ActiveRecord::Base
  belongs_to :course
  belongs_to :file_entity

  validates :course,
            :presence => true

  validates :file_entity_id,
            :presence   => true,
            :uniqueness => {:scope => :course_id}

  default_scope order('created_at DESC')
end
