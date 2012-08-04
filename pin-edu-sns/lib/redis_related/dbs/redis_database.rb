class RedisDatabase
  # DB 只能取 0 - 15 这十六个数字之一
  
  if Rails.env.test?
    TIP_DB   = 8
    QUEUE_DB = 9
    CACHE_DB = 10
    SEARCH_DB = 11
  else
    TIP_DB   = 0
    QUEUE_DB = 1
    CACHE_DB = 2
    SEARCH_DB = 3
  end

  def self.get_db_instance(db)
    redis = Redis.new(:thread_safe => true)
    redis.select(db)
    redis
  end
end
