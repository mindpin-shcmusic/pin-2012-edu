#! /usr/bin/env bash

current_path=`cd "$(dirname "$0")"; pwd`
edu_project_path=$current_path/../..
edu_sns_path=$edu_project_path/pin-edu-sns

. $current_path/../function.sh
MINDPIN_MRS_DATA_PATH=`ruby $edu_project_path/parse_property.rb MINDPIN_MRS_DATA_PATH`

processor_pid=`ruby $edu_project_path/get_sphinx_pid_file_path.rb`

cd $edu_sns_path
case "$1" in
        start)
                assert_process_from_pid_file_not_exist $processor_pid
                echo "thinking_sphinx start"
                rake ts:start
                command_status
        ;;
        stop)
                echo "thinking_sphinx stop"
                rake ts:stop
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

