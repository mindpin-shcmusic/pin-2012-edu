class BuildHomeworkAssignResqueQueue
  QUEUE_NAME = :build_homework_assign_resque_queue
  @queue = QUEUE_NAME

  def self.enqueue(homework_id)
    Resque.enqueue(BuildHomeworkAssignResqueQueue, homework_id)
  end

  def self.perform(homework_id)
    HomeworkAssignRule.find(homework_id).build_assign
  end
end
