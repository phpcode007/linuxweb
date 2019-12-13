# -*- coding: utf-8 -*-

from project import *



@app.route('/fileandterminal',methods=['GET', 'POST'])
def fileandterminal():

    result = subprocess.check_output(['/bin/sh', project_path + '/shell/diy/check_7033.sh'])

    #python3需要转换
    result = result.decode("UTF-8")

    public_ip_result = ''

    #读取外网ip
    try:
        f = open(ip_cache_path, 'r')
        public_ip_result = f.read()
    except:
        print('获取外网ip异常')



    return render_template('/fileandterminal/index.html',result=result,public_ip_result=public_ip_result)



@app.route('/install_fileandterminal',methods=['GET', 'POST'])
def install_fileandterminal():

    status_file = log_path + 'is_webterminal_web_running.status'

    try:

        with open(status_file, 'r') as f:
            status = f.read().rstrip("\n")

            if status == '2':
                print('已经安装过web终端')
                return '已经安装过web终端,不需要再安装'
            elif status == '1':
                print('正在执行安装web终端,请耐心等待一下')

                return '正在执行安装web终端,请耐心等待一下'
    except:
        subprocess.Popen(
            ['/bin/sh', project_path + '/shell/webterminal/webterminal.sh', downloadsoftware_and_config, software_install_path,log_path],
            cwd=shell_path)

        return '开始安装web终端'





