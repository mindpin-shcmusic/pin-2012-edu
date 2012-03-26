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
  if [ "$HOST" == "linux-edu" ];then
    echo "development"
  elif [ "$HOST" == "linux-mindpin" ];then
    echo "production"
  elif [ "$HOSTNAME" == "box" ];then
    echo "development"
  else
    echo "env HOST 必须是  linux-edu  或者 linux-mindpin"
    exit 5
  fi
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
