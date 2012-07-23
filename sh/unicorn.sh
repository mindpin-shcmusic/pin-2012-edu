#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
edu_project_path=$current_path/..
pin_edu_sns_dir=$edu_project_path/pin-edu-sns

. $current_path/function.sh

MINDPIN_MRS_DATA_PATH=`ruby $edu_project_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $edu_project_path/parse_property.rb RAILS_ENV` 

pin_edu_sns_pid=$MINDPIN_MRS_DATA_PATH/pids/unicorn-pin-edu-sns.pid

  case "$1" in
    pin-edu-sns)
     cd $pin_edu_sns_dir
     pid=$pin_edu_sns_pid
     echo "pin_edu_sns_dir"
    ;;
    *)
    echo "$1"
    echo "tip:(pin-edu-sns)"
    exit 5
    ;;
  esac
echo $rails_env
echo `pwd`
case "$2" in
	start)
        assert_process_from_pid_file_not_exist $pid
	echo "start"
	unicorn_rails -c config/unicorn.rb -E $rails_env -D
        command_status	
	;;
	stop)
	echo "stop"
	kill `cat $pid`
	command_status	
	;;
	usr2_stop)
	echo "usr2_stop"
        kill -USR2 `cat $pid`
        command_status
	;;
	restart)
	echo "restart"
	cd $sh_dir
	$0 "$1" stop
	sleep 1
	$0 "$1" start
	;;
	*)
	echo "tip:(start|stop|restart|usr2_stop)"
	exit 5
	;;
esac
exit 0

