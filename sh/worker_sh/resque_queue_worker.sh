#! /usr/bin/env bash


current_path=`cd "$(dirname "$0")"; pwd`
edu_project_path=$current_path/../..
edu_sns_path=$edu_project_path/pin-edu-sns

. $current_path/../function.sh

MINDPIN_MRS_DATA_PATH=`ruby $edu_project_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $edu_project_path/parse_property.rb RAILS_ENV` 

queue_name=$1
queue_worker_name="$queue_name"_worker


processor_pid=$MINDPIN_MRS_DATA_PATH/pids/"$queue_worker_name".pid
log_path=$MINDPIN_MRS_DATA_PATH/logs/"$queue_worker_name".log


cd $edu_sns_path

case "$2" in
  start)
    echo "start"
    assert_process_from_pid_file_not_exist $processor_pid
    VVERBOSE=1 INTERVAL=1 QUEUE=$queue_name RAILS_ENV=$rails_env rake environment resque:work 1>>$log_path 2>>$log_path &
    echo $! > $processor_pid
    command_status
  ;;
  stop)
    echo "stop"
    kill -9 `cat $processor_pid`
    command_status
  ;;
  restart)
    $0 stop
    sleep 1
    $0 start
  ;;
  pause)
    echo "pause"
    kill -12 `cat $processor_pid`
    command_status
  ;;
  cont)
    echo "cont"
    kill -18 `cat $processor_pid`
    command_status
  ;;
  *)
    echo "tip:(start|stop|restart|pause|cont)"
    exit 5
  ;;
esac

exit 0
