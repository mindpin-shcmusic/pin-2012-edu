class Team < ActiveRecord::Base
  
  belongs_to :teacher
  
  has_many :team_students
  has_many :students, :through => :team_students
  
  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |team| !team.cid.blank? } }

  def get_users
    [students, teacher].flatten.map(&:user)
  end
end
