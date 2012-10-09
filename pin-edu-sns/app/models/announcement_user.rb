class AnnouncementUser < ActiveRecord::Base
  belongs_to :announcement
  belongs_to :user
end
