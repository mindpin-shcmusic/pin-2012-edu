class UserShareRateTipMessage
  include Notifying

  class << self
    def notify_share_rank(user)
      Juggernaut.publish share_rank_channel(user),
                         rate_and_rank(user)
    end

    def share_rank_channel(user)
      make_channel(user, 'share-rank')
    end

    private

    def rate_and_rank(user)
      {:rate => user.share_rate, :rank => user.share_rank}
    end
  end
end