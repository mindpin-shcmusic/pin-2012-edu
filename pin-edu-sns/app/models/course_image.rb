class CourseImage < ActiveRecord::Base
  belongs_to :course

  has_one    :cover_course,
             :class_name  => 'Course',
             :foreign_key => :cover_id

  belongs_to :file_entity

  validates :course, :presence => true
  validates :file_entity_id, :presence => true,
    :uniqueness => {:scope => :course_id}

end
