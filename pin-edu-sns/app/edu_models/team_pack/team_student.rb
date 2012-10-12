class TeamStudent < ActiveRecord::Base
  belongs_to :team
  belongs_to :student_user, :class_name => 'User', :foreign_key => :student_user_id
  
  validates :student_user_id, :presence => true,
    :uniqueness => true

  validates :team, :presence => true
end
