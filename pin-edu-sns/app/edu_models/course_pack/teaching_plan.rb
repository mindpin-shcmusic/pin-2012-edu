class TeachingPlan < ActiveRecord::Base
  
  validates :title, :desc, :content, :presence => true
  has_many :chapters
  
  

end
