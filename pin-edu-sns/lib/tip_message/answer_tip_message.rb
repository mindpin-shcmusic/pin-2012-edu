class AnswerTipMessage < UserTipMessage
  def hash_name
    "answer:tip:message:#{self.user.id}"
  end

  def path
    "/answers/received"
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def answer_tip_message
        AnswerTipMessage.new(self)
      end
    end
  end
end
