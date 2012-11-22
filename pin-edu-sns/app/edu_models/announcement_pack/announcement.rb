class Announcement < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  has_many :announcement_users

  has_many :receivers,
           :through => :announcement_users,
           :source  => :user

  validates :content,
            :presence => true

  include Paginated
  include Pacecar
  
  def destroyable_by?(user)
    user.is_admin? || user == self.creator
  end

  def read_by?(user)
    get_announcement_user_by(user).read
  end

  def read_by!(user)
    get_announcement_user_by(user).update_attribute(:read, true)
  end

private

  def get_announcement_user_by(user)
    self.announcement_users.find_by_user_id(user.id)
  end

  module UserMethods
    def self.included(base)
      base.has_many :created_announcements,
                    :class_name  => 'Announcement',
                    :order => 'id DESC',
                    :foreign_key => :creator_id

      base.has_many :announcement_users

      base.has_many :received_announcements,
                    :through => :announcement_users,
                    :order => 'id DESC',
                    :source  => :announcement

      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def unread_announcements
        self.received_announcements.where('announcement_users.read = false')
      end

      def announcement_hash_name
        "user:anouncement:#{self.id}"
      end

      def announcement_path
        '/announcements?tab=received'
      end

    end

  end

  include AnnouncementRule::AnnouncementMethods
  include Paginated
end
