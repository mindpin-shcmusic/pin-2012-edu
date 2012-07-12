class ShortMessage < ActiveRecord::Base
  after_create Notify.new

  belongs_to :sender,
             :class_name  => 'User',
             :foreign_key => :sender_id

  belongs_to :receiver,
             :class_name  => 'User',
             :foreign_key => :receiver_id

  validates  :sender,
             :receiver,
             :content,
             :presence    => true

  validate   :not_the_same_user

  scope      :for_user,
             lambda {|user| where :receiver_id => user.id}

  scope      :unread,
             lambda {|user| for_user(user).where(:receiver_read => false, :receiver_hide => false)}

  def read!
    self.update_attribute :receiver_read, true
    self.class.notify_count(receiver)
  end

  def receiver_hide!
    self.update_attribute :receiver_hide, true
    self.class.notify_count(receiver)
  end

  def sender_hide!
    self.update_attribute :sender_hide, true
    self.class.notify_count(sender)
  end

  def self.any_unread?(user)
    self.unread(user).any? ? true : false
  end

  def self.channel(user)
    "short-message-count-#{user.id}"
  end

  def self.notify_count(user)
    Juggernaut.publish channel(user),
                       {:count => self.unread(user).count}
  end

  module UserMethods
    def self.included(base)
      base.has_many :received_messages,
                    :class_name  => 'ShortMessage',
                    :foreign_key => :receiver_id,
                    :conditions  => {:receiver_hide => false}

      base.has_many :sent_messages,
                    :class_name  => 'ShortMessage',
                    :foreign_key => :sender_id,
                    :conditions  => {:sender_hide => false}
    end
  end

  private

  def not_the_same_user
    errors.add :base,
               'can not send message to your self' if sender_id == receiver_id
  end
end
