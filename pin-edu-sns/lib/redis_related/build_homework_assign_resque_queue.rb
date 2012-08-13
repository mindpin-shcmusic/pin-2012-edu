class BuildHomeworkAssignResqueQueue
  QUEUE_NAME = :build_homework_assign_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(rule_id)
    Resque.enqueue(BuildHomeworkAssignResqueQueue, rule_id)
  end

  def self.perform(rule_id)
    HomeworkAssignRule.find(rule_id).build_assign
  end
end
