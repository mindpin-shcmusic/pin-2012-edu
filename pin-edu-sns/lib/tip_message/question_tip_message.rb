class QuestionTipMessage < UserTipMessage
  def hash_name
    "question:tip:message:#{self.user.id}"
  end

  def path
    "/questions/unanswered"
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def question_tip_message
        QuestionTipMessage.new(self)
      end
    end
  end
end
