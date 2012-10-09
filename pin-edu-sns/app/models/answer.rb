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


  module UserMethods
    def self.included(base)
      base.has_many :answers, :class_name  => 'Answer', :foreign_key => :creator_id
      base.send(:include,InstanceMethod)
    end
    
    module InstanceMethod
   
    end
  end

end
