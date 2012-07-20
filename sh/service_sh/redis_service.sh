#! /usr/bin/env bash

. $EDU_PROJECT_PATH/sh/function.sh
MINDPIN_MRS_DATA_PATH=$(get_mindpin_mrs_data_path)
REDIS_SERVER_PATH=$(redis_server_path)

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


