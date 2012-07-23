class Team < ActiveRecord::Base
  
  belongs_to :teacher
  
  has_many :team_students
  has_many :students, :through => :team_students
  
  validates :name, :presence => true
  validates :cid, :uniqueness => { :if => Proc.new { |team| !team.cid.blank? } }

  def get_user_ids
    [students, teacher].flatten.map(&:user_id).sort
  end

  def get_users
    User.find get_user_ids
  end
end
