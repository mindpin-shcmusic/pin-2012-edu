class Team < BuildDatabaseAbstract
  
  belongs_to :teacher
  
  has_many :team_students
  has_many :students, :through => :team_students
  
  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |team| !team.cid.blank? } }
  
  include TeamStatusLink::TeamMethods
end
