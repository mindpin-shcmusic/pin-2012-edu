class BuildMediaShareResqueQueue
  QUEUE_NAME = :build_media_share_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(media_share_id)
    Resque.enqueue(BuildMediaShareResqueQueue, media_share_rule_id)
  end

  def self.perform(media_share_id)
    MediaShareRule.find(media_share_id).build_share
  end
end
