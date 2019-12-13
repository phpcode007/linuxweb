#!/bin/bash

if [ -f "$2/nginx/sbin/nginx" ]
then
  echo '1'
else
  echo '0'
fi

#nginx_port=$(netstat -tnlp | grep nginx)
#
#if [[ ! $nginx_port ]]
#then
#    echo "0"
#else
#  echo "1"
#fi