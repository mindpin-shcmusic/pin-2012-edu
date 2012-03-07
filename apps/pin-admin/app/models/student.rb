class Student < ActiveRecord::Base
  belongs_to :user
  
  validates :real_name, :presence=>true
  validates :sid, :uniqueness => { :if => Proc.new { |student| !student.sid.blank? } }
end
