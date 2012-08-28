class CourseImage < ActiveRecord::Base
  class Kind
    ATTACHMENT = "ATTACHMENT"
    COVER = "COVER"
  end

  belongs_to :course
  belongs_to :file_entity

  validates :course, :presence => true
  validates :file_entity_id, :presence => true,
    :uniqueness => {:scope => :course_id}
  validates :kind, :presence => true, 
    :inclusion => [Kind::ATTACHMENT,Kind::COVER],
    :uniqueness => {:scope => :course_id,:if=> Proc.new { |course_image|course_image.kind == Kind::COVER }}



end
