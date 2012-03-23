class Course < BuildDatabaseAbstract
  belongs_to :teacher
  
  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |course| !course.cid.blank? } }
end
