class RedisSearch < RedisDatabase
  def self.instance
    @@instance ||= self.get_db_instance(RedisDatabase::SEARCH_DB)
  end
end