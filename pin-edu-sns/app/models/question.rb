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
