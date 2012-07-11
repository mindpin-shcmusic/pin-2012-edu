class Notify
  def after_create(record)
    record.class.notify_count(record.receiver)
    record.publish(record.receiver)
  end

  def after_destroy(record)
    record.class.notify_count(record.receiver)
  end
end

class Notification < ActiveRecord::Base
  after_create  ::Notify.new
  after_destroy ::Notify.new

  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  default_scope order('created_at DESC')

  scope      :for_user,
             lambda {|user| where :receiver_id => user.id}

  scope      :unread,
             lambda {|user| for_user(user).where :read => false}

  def self.any_unread?(user)
    self.unread(user).any? ? true : false
  end

  def self.notify_count(user)
    Juggernaut.publish "notification-count-user-#{user.id}",
                       {:count => self.unread(user).count}
  end

  def self.notify_read_all(user)
    Juggernaut.publish "notification-read-all-user-#{user.id}",
                       {:all => true}
  end

  def self.read_all!(user)
    unread(user).update_all(:read => true)
    notify_count(user)
    notify_read_all(user)
  end

  def publish(user)
    Juggernaut.publish "incoming-notification-user-#{user.id}",
                       {:content    => content,
                        :read       => read,
                        :created_at => created_at,
                        :id         => id}
  end

  private

  module UserMethods
    def self.included(base)
      base.has_many :notifications,
                    :foreign_key => :receiver_id
    end
  end
end
