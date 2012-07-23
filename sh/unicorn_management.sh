#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
edu_project_path=$current_path/..

. $current_path/function.sh

MINDPIN_MRS_DATA_PATH=`ruby $edu_project_path/parse_property.rb MINDPIN_MRS_DATA_PATH`
rails_env=`ruby $edu_project_path/parse_property.rb RAILS_ENV` 

pid=$MINDPIN_MRS_DATA_PATH/pids/unicorn-management.pid

cd $edu_project_path/management

case "$1" in
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
		$current_path/`basename $0` stop
		sleep 1
		$current_path/`basename $0` start
		;;
	*)
		echo "tip:(start|stop|restart|usr2_stop)"
		exit 5
	;;
esac
exit 0
