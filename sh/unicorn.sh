#! /usr/bin/env bash

pin_2012_edu_dir=`dirname $0`/..

pin_auth_dir=$pin_2012_edu_dir/apps/pin-auth
pin_auth_pid=/web/2012/pids/unicorn-pin-auth.pid

pin_admin_dir=$pin_2012_edu_dir/apps/pin-admin
pin_admin_pid=/web/2012/pids/unicorn-pin-admin.pid

pin_edu_sns_dir=$pin_2012_edu_dir/apps/pin-edu-sns
pin_edu_sns_pid=/web/2012/pids/unicorn-pin-edu-sns.pid

sh_dir=`dirname $0`
. $sh_dir/function.sh
rails_env=$(get_rails_env)

  case "$1" in
    pin-auth)
     cd $pin_auth_dir
     pid=$pin_auth_pid
     echo "pin_auth_dir"
    ;;
    pin-admin)
     cd $pin_admin_dir
     pid=$pin_admin_pid
     echo "pin_admin_dir"
    ;;
    pin-edu-sns)
     cd $pin_edu_sns_dir
     pid=$pin_edu_sns_pid
     echo "pin_edu_sns_dir"
    ;;
    *)
    echo "$1"
    echo "tip:(pin-auth|pin-admin|pin-edu-sns)"
    exit 5
    ;;
  esac
echo $rails_env
echo `pwd`
case "$2" in
	start)
        assert_process_from_pid_file_not_exist $pid
	echo "start"
	unicorn_rails -c config/unicorn.rb -D -E $rails_env
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

