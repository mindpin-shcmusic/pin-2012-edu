class Teacher < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :real_name
  validates_uniqueness_of :tid, :if => Proc.new { |teacher| !teacher.tid.blank? }
end
