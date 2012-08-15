class UserShareRateTipMessage < UserTipMessage
  def hash_name
    "user:tip:message:share_rate:#{self.user.id}"
  end

  def path
    '/notification/share_rate'
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def share_rate_tip_message
        UserShareRateTipMessage.new(self)
      end

      def rate_and_rank
        {:rate => self.share_rate, :rank => self.share_rank}
      end
    end
  end
end
