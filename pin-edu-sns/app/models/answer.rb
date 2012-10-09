# -*- coding: utf-8 -*-
class Answer < ActiveRecord::Base
  belongs_to :creator,
             :class_name  => 'User',
             :foreign_key => :creator_id


  belongs_to :question,
             :class_name  => 'Question',
             :foreign_key => :question_id

  after_save :set_question_answered

  def set_question_answered
    self.question.has_answered = true
    self.question.save
  end

  after_create :send_tip_message_for_receiver_on_create
  def send_tip_message_for_receiver_on_create
    receiver = self.question.teacher_user

    receiver.comment_tip_message.put("#{self.creator.name} 给你发了问题", self.id)
    receiver.comment_tip_message.send_count_to_juggernaut
  end

  after_destroy :send_tip_message_on_destroy
  def send_tip_message_on_destroy
    receiver = self.question.teacher_user

    if !receiver.blank?
      receiver.comment_tip_message.delete(self.id)
      receiver.comment_tip_message.send_count_to_juggernaut
    end
  end


  module UserMethods
    def self.included(base)
      base.has_many :answers, :class_name  => 'Answer', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
   
    end
  end

end
