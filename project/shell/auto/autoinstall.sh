#!/bin/bash

source ./config.sh

echo $downloadsoftware_and_config
echo $software_install_path

#系统初始化
sh ../systeminit/systeminit.sh $downloadsoftware_and_config $software_install_path $log_path
#安装nginx
sh ../nginx/nginx.sh $downloadsoftware_and_config $software_install_path $log_path
#安装php
sh ../php/php.sh $downloadsoftware_and_config $software_install_path $log_path
#安装redis
sh ../redis/redis.sh $downloadsoftware_and_config $software_install_path $log_path
#安装mysql
sh ../mysql/mysql.sh $downloadsoftware_and_config $software_install_path $log_path