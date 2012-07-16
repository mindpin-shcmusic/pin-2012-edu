class UserCommentTipMessage < UserTipMessage
  class << self
    def url(user)
      '/comments/inbox'
    end

    protected

    def key(user)
      "utm:cmt:#{user.id}"
    end
  end
end
