#! /usr/bin/env bash

pin_2012_edu_dir=`dirname $0`/..

pin_edu_sns_dir=$pin_2012_edu_dir/pin-edu-sns
pin_edu_sns_pid=/MINDPIN_MRS_DATA/pids/unicorn-pin-edu-sns.pid

sh_dir=`dirname $0`
. $sh_dir/function.sh
rails_env=$(get_rails_env)

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

