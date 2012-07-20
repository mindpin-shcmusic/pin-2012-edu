#! /usr/bin/env bash

. $EDU_PROJECT_PATH/sh/function.sh
MINDPIN_MRS_DATA_PATH=$(get_mindpin_mrs_data_path)

processor_pid=$MINDPIN_MRS_DATA_PATH/pids/juggernaut_service.pid
log_file=$MINDPIN_MRS_DATA_PATH/logs/juggernaut_service.log

case "$1" in
        start)
                assert_process_from_pid_file_not_exist $processor_pid
                echo "juggernaut start"
                juggernaut 1>> $log_file 2>> $log_file &
                command_status
                echo $! > $processor_pid
        ;;
        stop)
                echo "juggernaut stop"
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


