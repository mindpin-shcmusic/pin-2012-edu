class ShortMessage < ActiveRecord::Base
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

  scope      :unread, where('receiver_read = false AND receiver_hide = false')

  after_create :send_count_for_receiver_on_create
  def send_count_for_receiver_on_create
    self.send_count_to_juggernaut
  end

  after_save :send_count_for_receiver_on_save
  def send_count_for_receiver_on_save
    self.send_count_to_juggernaut
  end

  def send_count_to_juggernaut
    Juggernaut.publish self.receiver.short_message_count_channel,
                       {:count => self.receiver.unread_messages.count}
  end

  def read!
    self.update_attribute :receiver_read, true
  end

  def receiver_hide!
    self.update_attribute :receiver_hide, true
  end

  def sender_hide!
    self.update_attribute :sender_hide, true
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

      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def unread_messages
        self.received_messages.unread
      end

      def short_message_count_channel
        "user:short_message:count:#{self.id}"
      end

    end

  end

  private

  def not_the_same_user
    errors.add :base,
               'can not send message to your self' if sender_id == receiver_id
  end
end
