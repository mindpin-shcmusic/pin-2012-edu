class BuildAnnouncementResqueQueue
  QUEUE_NAME = :build_announcement_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(rule_id)
    Resque.enqueue(BuildAnnouncementResqueQueue, rule_id)
  end

  def self.perform(rule_id)
    AnnouncementRule.find(rule_id).build_announcement
  end
end
