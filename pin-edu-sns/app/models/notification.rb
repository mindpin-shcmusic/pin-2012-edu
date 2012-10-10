class Notification < ActiveRecord::Base
  include Notifying
  @@notify = Notify.new

  after_create  @@notify
  after_destroy @@notify

  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  default_scope order('created_at DESC')

  class << self
    def any_unread?(user)
      self.unread(user).any? ? true : false
    end

    def notify_read_all(user)
      Juggernaut.publish make_channel(user, 'read-all'),
                         {:all => true}
    end

    def read_all!(user)
      unread(user).update_all(:read => true)
      notify_count(user)
      notify_read_all(user)
    end

    protected

    def unread_count(user)
      unread(user).count
    end

    def unread_conditions
      {:read => false}
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
