module PathConfig
  PIN_2012_EDU_PATH = File.join(File.dirname(File.expand_path(__FILE__)),"../../")

  UNICORN_SH_PATH = File.join(PIN_2012_EDU_PATH,"sh")
  WORKER_SH_PATH = File.join(PIN_2012_EDU_PATH,"sh/worker_sh")
  SERVERS_SH_PATH = File.join(PIN_2012_EDU_PATH,"sh/service_sh")

  REDIS_SERVICE_SH = File.join(SERVERS_SH_PATH,"redis_service.sh")
  RESQUE_WEB_SH = File.join(SERVERS_SH_PATH,"resque_web_service.sh")
  JUGGERNAUT_SH = File.join(SERVERS_SH_PATH,"juggernaut_service.sh")
  THINKING_SPHINX_SH = File.join(SERVERS_SH_PATH,"thinking_sphinx_service.sh")

  PROJECTS = ["pin-edu-sns"]

  QUEUES = [
    "build_media_share_resque_queue",
    "file_entity_video_encode_resque_queue",
    'build_homework_assign_resque_queue',
    'upload_file_entity_to_aliyun_oss_resque_queue'
  ]
end
