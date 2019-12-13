#!/bin/bash

#注意路径最后面不要添加/线

#下载软件和配置文件路径
downloadsoftware_and_config=$(pwd)/../software
#软件安装路径
software_install_path=/data/software
#日志路径
log_path=/var/log/flask







mkdir -p $downloadsoftware_and_config
mkdir -p $software_install_path
mkdir -p $log_path