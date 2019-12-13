#!/bin/bash


if [[ $4 == '1' ]]
then
  rm -rf $3/is_nginx_web_running.status
fi


if [[ $5 == '1' ]]
then
  rm -rf $3/is_php_web_running.status
fi

if [[ $6 == '1' ]]
then
  rm -rf $3/is_redis_web_running.status
fi

if [[ $7 == '1' ]]
then
  rm -rf $3/is_mysql_web_running.status
fi



if [[ $8 == '1' ]]
then
  rm -rf $3/is_webterminal_web_running.status
  #还需要关闭node进程
  ps aux | grep cloudcmd  | grep -v grep | awk '{print $2}' | xargs kill -9
fi


if [[ $9 == '1' ]]
then
  rm -rf $2/nginx/html/*.phpmysqladmin.com
  rm -rf $2/nginx/conf/vhost/*.phpmysqladmin.com.conf
  rm -rf $3/is_phpmysqladmin_web_running.status
fi