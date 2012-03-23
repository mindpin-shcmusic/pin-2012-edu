class TeamStudent < BuildDatabaseAbstract
  belongs_to :team
  belongs_to :student
  
  validates :team, :student, :presence=>true
end
