class Teacher < ActiveRecord::Base
  belongs_to :user
  
  validates :real_name, :presence => true
  validates :tid, :uniqueness => { :if => Proc.new { |teacher| !teacher.tid.blank? } }
end
