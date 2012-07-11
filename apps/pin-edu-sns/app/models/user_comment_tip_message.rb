class UserCommentTipMessage < UserTipMessage
  class << self
    def url(user)
      '/comments/inbox'
    end

    protected

    def channel(user)
      "comment-message-count-user-#{user.id}"
    end

    def key(user)
      "utm:cmt:#{user.id}"
    end
  end
end
