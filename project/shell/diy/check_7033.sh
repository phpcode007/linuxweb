#!/bin/bash

port_7033=$(netstat -tnlp | grep :7033)

if [[ ! $port_7033 ]]
then
#  echo "没有运行web终端"
#  echo "0"
    echo "0"
else
  echo "1"
fi