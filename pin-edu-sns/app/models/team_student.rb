class TeamStudent < ActiveRecord::Base
  belongs_to :team
  belongs_to :student_user, :class_name => 'User', :foreign_key => :student_user_id
  
  validates :team, :student_user, :presence=>true
end
