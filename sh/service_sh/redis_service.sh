#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
edu_project_path=$current_path/../..

. $current_path/../function.sh

MINDPIN_MRS_DATA_PATH=`ruby $edu_project_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
REDIS_SERVER_PATH=`ruby $edu_project_path/parse_property.rb REDIS_SERVER_PATH`

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/redis_service.pid
log_file=$MINDPIN_MRS_DATA_PATH/logs/redis_service.log

case "$1" in
        start)
                assert_process_from_pid_file_not_exist $processor_pid
                echo "redis_service start"
                cd $REDIS_SERVER_PATH
                ./src/redis-server 1>> $log_file 2>> $log_file & 
                command_status
                echo $! > $processor_pid
        ;;
        stop)
                echo "redis_service stop"
                kill -9 `cat $processor_pid`
                command_status
        ;;
        restart)
                $0 stop
                sleep 1
                $0 start
        ;;
        *)
                echo "tip:(start|stop|restart)"
                exit 5
        ;;
esac
exit 0


