# -*- coding: utf-8 -*-
__version__ = '0.1'
import random
import string
import os
import datetime
import sys
import subprocess
import requests


from subprocess import PIPE
import time


from flask import Flask
from flask_debugtoolbar import DebugToolbarExtension

from project.config.common import *


import psutil
import socket
import platform
from flask import request, json,flash,url_for
from werkzeug.exceptions import HTTPException
from flask import render_template, request, redirect,session


from project.utils.exception.ApiException import ApiException

import wtforms_json
wtforms_json.init()


# import logging
# logging.basicConfig(level=logging.INFO)

#判断是不是root用户
if os.geteuid() != 0:
    print("这个程序需要使用root用户运行.")
    sys.exit(1)

#处理utf8编码,统一python2和python3的编码,两个版本测试通过
defaultencoding = 'utf-8'
if sys.getdefaultencoding() != defaultencoding:
    reload(sys)
    sys.setdefaultencoding(defaultencoding)


app = Flask(project_name)
app.config['SECRET_KEY'] = project_secret_key
app.debug = project_debug
# app.config['DEBUG'] = True
toolbar = DebugToolbarExtension(app)

#session过期时间10分钟
app.permanent_session_lifetime = datetime.timedelta(seconds=project_session_timeout)

#flask返回结果中支持中文
app.config['JSON_AS_ASCII'] = False

if os.path.exists('/var/log/flaskuserpwd.txt'):
    # print('文件存在,不需要再创建用户名和密码')
    pass
else:
    print('创建用户名和密码')

    username = ''.join(random.choice(string.ascii_lowercase) for _ in range(8))

    password = ''.join(random.choice(string.ascii_letters) for i in range(14))
    password = password[:7] + '#' + password[7:]

    with open('/var/log/flaskuserpwd.txt', 'w') as f:
        f.write(username)
        f.write('\n')  #写入换行
        f.write(password)


# print('导入一次了')

#启动web终端，跟隋进程退出更安全
subprocess.Popen(
    ['/bin/sh', project_path + '/shell/webterminal/start.sh', downloadsoftware_and_config, software_install_path],
    cwd=shell_path)


from project.controllers import *
