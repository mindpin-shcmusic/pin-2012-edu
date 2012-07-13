module Notifying
  def self.included(base)
    base.send :include,
              InstanceMethods

    base.send :extend,
              ClassMethods
  end

  module ClassMethods
    def for_user(user)
      where :receiver_id => user.id
    end

    protected

    def notify_count(user, count)
      Juggernaut.publish count_channel(user),
                         count
    end

    def count_channel(user)
      make_channel(user, 'count')
    end

    def publish_channel(user)
      make_channel(user, 'publish')
    end

    def channel_base
      self.to_s.underscore.dasherize
    end

    def make_channel(user, channel_identifier)
      "#{channel_base}-#{channel_identifier}-user-#{user.id}"
    end

    def unread_collection(user, conditions)
      for_user(user).where conditions
    end
  end

  module InstanceMethods
    def publish(user, content)
      Juggernaut.publish self.class.send(:publish_channel, user),
                         content
    end
  end
end
