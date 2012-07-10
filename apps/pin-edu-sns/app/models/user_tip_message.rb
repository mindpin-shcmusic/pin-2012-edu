class UserTipMessage < RedisTip
  class << self
    def send(user, message_str)
      instance.lpush message_list_name(user), message_str
      notify_count(user)
    end

    def count(user)
      instance.llen message_list_name(user)
    end

    def clear(user)
      instance.del message_list_name(user)
      notify_count(user)
    end

    def url(user)
      "/users/#{user.id}/message_list"
    end

    private

    def notify_count(user)
      Juggernaut.publish "message-count-user-#{user.id}",
                         {:messages => count(user)}
    end

    def message_list_name(user)
      "utm:#{user.id}"
    end
  end
end
