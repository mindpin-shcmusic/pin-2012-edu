class Notification < ActiveRecord::Base
  include Notifying

  after_create  Notify.new
  after_destroy Notify.new

  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  default_scope order('created_at DESC')

  scope      :unread,
             lambda {|user| unread_collection(user, :read => false)}

  class << self
    def any_unread?(user)
      self.unread(user).any? ? true : false
    end

    def notify_count(user)
      super user,
            {:count => unread(user).count}
    end

    def notify_read_all(user)
      Juggernaut.publish "notification-read-all-user-#{user.id}",
                         {:all => true}
    end

    def read_all!(user)
      unread(user).update_all(:read => true)
      notify_count(user, {:count => unread(user).count})
      notify_read_all(user)
    end
  end

  def publish(user)
    super user, attributes
  end

  private

  module UserMethods
    def self.included(base)
      base.has_many :notifications,
                    :foreign_key => :receiver_id
    end
  end
end
