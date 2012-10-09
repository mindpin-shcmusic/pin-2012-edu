class Question < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id

  has_one :answer
  has_one :teacher_user,
          :class_name  => 'User',
          :foreign_key => 'teacher_user_id'


  scope :with_teacher, lambda {|teacher| {:conditions => ['teacher_user_id = ?', teacher.id]}}
  scope :answered, where(:has_answered => true)
  scope :unanswered, where(:has_answered => false)


  after_create :send_tip_message_for_receiver_on_create
  def send_tip_message_for_receiver_on_create
    receiver = self.teacher_user

    receiver.question_tip_message.put("#{self.creator.name} 给你发了问题", self.id)
    receiver.question_tip_message.send_count_to_juggernaut
  end

  after_destroy :send_tip_message_on_destroy
  def send_tip_message_on_destroy
    receiver = self.teacher_user

    if !receiver.blank?
      receiver.question_tip_message.delete(self.id)
      receiver.question_tip_message.send_count_to_juggernaut
    end
  end



  module UserMethods
    def self.included(base)
      base.has_many :questions, :class_name => 'Question', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
      def unread_messages
        self.received_messages.unread
      end

      def question_count_channel
        "user:question:count:#{self.id}"
      end
    end
  end

  include ModelRemovable

end
