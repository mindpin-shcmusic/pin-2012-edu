#! /usr/bin/env bash

if [ -z $EDU_PROJECT_PATH ];then
	echo "没有设置 EDU_PROJECT_PATH 环境变量"
	exit 5
fi

. $EDU_PROJECT_PATH/sh/function.sh
MINDPIN_MRS_DATA_PATH=$(get_mindpin_mrs_data_path)

pid=$MINDPIN_MRS_DATA_PATH/pids/unicorn-management.pid
sh_dir_path=$EDU_PROJECT_PATH/sh
rails_env=$(get_rails_env)

cd $EDU_PROJECT_PATH/management

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
		$sh_dir_path/`basename $0` stop
		sleep 1
		$sh_dir_path/`basename $0` start
		;;
	*)
		echo "tip:(start|stop|restart|usr2_stop)"
		exit 5
	;;
esac
exit 0
