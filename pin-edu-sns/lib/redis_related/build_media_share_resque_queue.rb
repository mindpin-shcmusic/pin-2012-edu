class BuildMediaShareResqueQueue
  QUEUE_NAME = :build_media_share_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(media_share_rule_id, deleting_ids)
    Resque.enqueue(BuildMediaShareResqueQueue, media_share_rule_id, deleting_ids)
  end

  def self.perform(media_share_rule_id)
    MediaShareRule.find(media_share_rule_id).build_share(deleting_ids)
  end
end
