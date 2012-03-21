class TeamStatusLink < BuildDatabaseAbstract
  belongs_to :team
  belongs_to :status
  
  module TeamMethods
    def self.included(base)
      base.has_many :team_status_links
      base.has_many :statuses, :through => :team_status_links
    end
  end
end
