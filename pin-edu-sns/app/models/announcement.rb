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

  module UserMethods
    def self.included(base)
      base.has_many :created_announcements,
                    :class_name  => 'Announcement',
                    :foreign_key => :creator_id

      base.has_many :announcement_users

      base.has_many :received_announcements,
                    :through => :announcement_users,
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
        '/announcements/received'
      end

    end

  end

  include AnnouncementRule::AnnouncementMethods
end
