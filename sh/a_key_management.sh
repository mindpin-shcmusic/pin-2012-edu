#! /usr/bin/env bash

case "$1" in
  start)
    ./service_sh/redis_service.sh start
    ./service_sh/resque_web_service.sh start
    ./service_sh/juggernaut_service.sh start
    ./service_sh/thinking_sphinx_service.sh start

    ./worker_sh/resque_queue_worker.sh build_media_share_resque_queue start
    ./worker_sh/resque_queue_worker.sh file_entity_video_encode_resque_queue start
    ./worker_sh/resque_queue_worker.sh build_homework_assign_resque_queue start
    ./worker_sh/resque_queue_worker.sh build_announcement_resque_queue start
    ./worker_sh/resque_queue_worker.sh upload_file_entity_to_aliyun_oss_resque_queue start

    ./unicorn_management.sh start
    ./unicorn.sh pin-edu-sns start
    ;;
  stop)
    ./unicorn_management.sh stop
    ./unicorn.sh pin-edu-sns stop

    ./service_sh/redis_service.sh stop
    ./service_sh/resque_web_service.sh stop
    ./service_sh/juggernaut_service.sh stop
    ./service_sh/thinking_sphinx_service.sh stop
  ;;    
  *)
    echo "tip:(stop|start)"
    exit 5
  ;;
esac
