# -*- coding: utf-8 -*-
class AnnouncementUser < ActiveRecord::Base
  belongs_to :announcement
  belongs_to :user

  after_destroy :send_tip_message_on_destroy
  after_create  :send_tip_message_on_create

  validates :announcement,
            :user,
            :presence => true

  validate :exclude_creator

private

  def send_tip_message_on_destroy
    Juggernaut.publish self.user.announcement_hash_name,
                       {:count => user.unread_announcements.count}
  end

  def send_tip_message_on_create
    self.send_count_to_juggernaut self.user.announcement_hash_name,
                                  self.user.unread_announcements.count
  end

  def send_count_to_juggernaut(channel, count)
    Juggernaut.publish channel, {:count => count}
  end

  def exclude_creator
    errors.add :base,
               '不能向自己发送通知' if self.user == self.announcement.creator
  end

end
