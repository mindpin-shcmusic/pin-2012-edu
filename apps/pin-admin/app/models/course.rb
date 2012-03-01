class Course < ActiveRecord::Base
  belongs_to :teacher
  
  validates_presence_of :name
  validates_uniqueness_of :cid, :if => Proc.new { |course| !course.cid.blank? }
end
