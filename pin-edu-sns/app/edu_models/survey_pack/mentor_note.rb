class MentorNote < ActiveRecord::Base
  has_many :mentor_students, :dependent => :destroy

  validates :title, :presence => true
end
