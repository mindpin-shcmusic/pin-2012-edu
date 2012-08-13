class BuildMediaShareResqueQueue
  QUEUE_NAME = :build_media_share_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(rule_id)
    Resque.enqueue(BuildMediaShareResqueQueue, rule_id)
  end

  def self.perform(rule_id)
    MediaShareRule.find(rule_id).build_share
  end
end
