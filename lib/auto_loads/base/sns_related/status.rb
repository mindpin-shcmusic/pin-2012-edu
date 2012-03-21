class Status < BuildDatabaseAbstract
  belongs_to :creator, :class_name => 'User', :foreign_key => :creator_id
  belongs_to :repost, :class_name => 'Status', :foreign_key => :repost_id
  has_many :team_status_links
  has_many :teams, :through => :team_status_links
  
  default_scope order("created_at DESC")
  
  validates :creator, :content, :presence => true
  validate :at_least_one_team
  def at_least_one_team
    if self.teams.blank?
      errors.add(:teams,"至少指定一个班级")
    end
  end
  
  def do_repost(content,creator,teams)
    if self.repost.blank?
      rep = self
    else
      rep = self.repost
    end
    status = Status.new(:content=>content,:creator=>creator,:teams=>teams,:repost=>rep)
    if !status.save
      error = status.errors.first
      raise "#{error[0]} #{error[1]}"
    end
    status
  end
end
