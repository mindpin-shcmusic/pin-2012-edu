class TestQuestion < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  belongs_to :teaching_plan

  validates :title, :teaching_plan, :creator, :presence => true
end
