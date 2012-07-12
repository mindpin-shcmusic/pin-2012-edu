class Notify
  def after_create(record)
    record.class.notify_count(record.receiver)
    record.respond_to?(:publish) &&
    record.publish(record.receiver)
  end

  def after_destroy(record)
    record.class.notify_count(record.receiver)
  end
end
