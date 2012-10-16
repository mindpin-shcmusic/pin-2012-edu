# -*- coding: utf-8 -*-
class AnnouncementUser < ActiveRecord::Base
  belongs_to :announcement
  belongs_to :user

  after_destroy :send_count_to_juggernaut
  after_create  :send_count_to_juggernaut

  validates :announcement,
            :user,
            :presence => true

  validate :exclude_creator

private

  def send_count_to_juggernaut
    Juggernaut.publish self.user.announcement_hash_name,
                       {:count => self.user.unread_announcements.count}
  end

  def exclude_creator
    errors.add :base,
               '不能向自己发送通知' if self.user == self.announcement.creator
  end

end
