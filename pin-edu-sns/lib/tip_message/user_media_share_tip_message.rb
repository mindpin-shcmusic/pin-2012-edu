class UserMediaShareTipMessage < UserTipMessage
  def hash_name
    "user:tip:message:media_share:#{self.user.id}"
  end

  def path
    '/notification/media_share'
  end

  module UserMethods
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def media_share_tip_message
        UserMediaShareTipMessage.new(self)
      end
    end
  end
end
