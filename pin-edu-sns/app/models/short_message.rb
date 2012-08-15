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

  after_save :send_a

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
    end
  end

  private

  def not_the_same_user
    errors.add :base,
               'can not send message to your self' if sender_id == receiver_id
  end
end
