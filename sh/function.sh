#! /usr/bin/env bash

function assert_process_from_name_not_exist(){
local pid
pid=$(ps aux|grep $1|grep -v grep|awk '{print $2}')
if [ "$pid" ];then
echo "已经有一个 $1 进程在运行"
exit 5
fi
}

function assert_process_from_pid_file_not_exist()
{
local pid;

if [ -f $1 ]; then
pid=$(cat $1)
if [ $pid ] && [ "$(ps $pid|grep -v PID)" ]; then
echo "$1 pid_file 中记录的 pid 还在运行"
exit 5
fi
fi
}

function get_rails_env()
{
  echo -n `ruby $EDU_PROJECT_PATH/parse_property.rb RAILS_ENV` 
}

function get_sh_dir_path()
{
echo $(cd "$(dirname "$0")"; pwd)
}

function command_status()
{
if [ $? == 0 ];then
echo "success"
else
echo "fail"
fi
}

function get_mindpin_mrs_data_path()
{
  echo -n `ruby $EDU_PROJECT_PATH/parse_property.rb MINDPIN_MRS_DATA_PATH`
}

function redis_server_path()
{
  echo -n `ruby $EDU_PROJECT_PATH/parse_property.rb REDIS_SERVER_PATH` 
}
