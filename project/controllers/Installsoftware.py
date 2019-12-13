# -*- coding: utf-8 -*-
# from project import app
# from project import ApiException
# from werkzeug.exceptions import HTTPException
# from flask import render_template, request, redirect,session
# from flask import request, json
from project import *
# from project.config.common import *
# from project.models.CheckParams import *







@app.route('/installsoftware')
def installsoftware():
    return render_template('installsoftware/index.html')

@app.route('/installsoftware/systeminit',methods=['GET', 'POST'])
def systeminit():

    status_file = log_path + 'is_systeminit_web_running.status'



    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('系统初始化已经执行完毕')
                return '已经执行过一次,不再需要执行系统初始化'
            elif status == '1':
                print('系统初始化正在执行,请耐心等待一下')

                return '系统初始化正在执行,请耐心等待一下'
    except:
        subprocess.Popen(['/bin/sh',project_path + '/shell/systeminit/systeminit.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)

        return '开始执行系统初始化'



@app.route('/installsoftware/nginx',methods=['GET', 'POST'])
def nginx():

    status_file = log_path + 'is_nginx_web_running.status'

    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('已经安装过nginx')
                return '已经安装过nginx,不需要再安装'
            elif status == '1':
                print('正在执行安装nginx,请耐心等待一下')

                return '正在执行安装nginx,请耐心等待一下'
    except:
        subprocess.Popen(['/bin/sh',project_path + '/shell/nginx/nginx.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)

        return '开始安装nginx'




@app.route('/installsoftware/php7312',methods=['GET', 'POST'])
def php7312():

    status_file = log_path + 'is_php_web_running.status'



    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('已经安装过php-7.3.12')
                return '已经安装过php-7.3.12,不需要再安装'
            elif status == '1':
                print('正在执行安装php-7.3.12,请耐心等待一下')

                return '正在执行安装php-7.3.12,请耐心等待一下'
    except:
        subprocess.Popen(['/bin/sh',project_path + '/shell/php/php.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)

        return '开始安装php-7.3.12'





@app.route('/installsoftware/redis',methods=['GET', 'POST'])
def redis():

    status_file = log_path + 'is_redis_web_running.status'


    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('已经安装过redis-5.0.7')
                return '已经安装过redis-5.0.7,不需要再安装'
            elif status == '1':
                print('正在执行安装redis-5.0.7,请耐心等待一下')

                return '正在执行安装redis-5.0.7,请耐心等待一下'
    except:
        subprocess.Popen(['/bin/sh',project_path + '/shell/redis/redis.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)

        return '开始安装redis-5.0.7'



@app.route('/installsoftware/mysql',methods=['GET', 'POST'])
def mysql():

    status_file = log_path + 'is_mysql_web_running.status'

    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('已经安装过mysql-5.7.28.tar.gz')
                return '已经安装过mysql-5.7.28.tar.gz,不需要再安装'
            elif status == '1':
                print('正在执行安装mysql-5.7.28.tar.gz,请耐心等待一下')

                return '正在执行安装mysql-5.7.28.tar.gz,请耐心等待一下'
    except:
        subprocess.Popen(['/bin/sh',project_path + '/shell/mysql/mysql.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)

        return '开始安装mysql-5.7.28.tar.gz'