#!/usr/bin/env python
# -*- coding:utf8 -*-
import os

#项目名字
project_name = 'project'
#安全key
project_secret_key = 'random'
#是否开启debug模式
project_debug = False
#session过期时间10分钟
project_session_timeout = 1000*60

project_path  = os.path.abspath(__file__)
project_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


#shell执行路径
shell_path = project_path + '/shell/systeminit/'
#下载软件和配置文件路径
downloadsoftware_and_config = project_path + '/shell/software'
#软件安装路径
software_install_path = '/data/software'

#日志路径
log_path = '/var/log/flask/'


#外网ip缓存文件
ip_cache_path = '/var/log/publicip.txt'