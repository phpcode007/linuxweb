# -*- coding: utf-8 -*-

from project import *

@app.route('/softwareconfig')
def softwareconfig():
    #
    # #先判断有没有安装nginx
    # result = subprocess.check_output(
    #     ['/bin/sh', project_path + '/shell/nginx/check_nginx_status.sh', downloadsoftware_and_config,
    #      software_install_path],cwd=shell_path)
    #
    return render_template('softwareconfig/index.html')


@app.route('/softwareconfig/clear',methods=['GET', 'POST'])
def softwareconfigclear():
    if request.method == 'POST':
        nginx = request.json['nginx']
        php = request.json['php']
        redis = request.json['redis']
        mysql = request.json['mysql']

        webterminal = request.json['webterminal']

        phpmysqladmin = request.json['phpmysqladmin']


        #根据对应的状态来清除
        result = subprocess.check_output(
            ['/bin/sh', project_path + '/shell/clear/clear_install_status.sh',
                downloadsoftware_and_config,software_install_path,log_path,
              nginx,php,redis,mysql,webterminal,phpmysqladmin],cwd=shell_path)


        return '清除安装状态成功'
    else:

        return render_template('softwareconfig/index.html')




@app.route('/softwareconfig/mysqladmin',methods=['GET', 'POST'])
def softwareconfigmysqladmin():
    if request.method == 'POST':

        # subprocess.Popen(['/bin/sh',project_path + '/shell/diy/phpmysqladmin.sh',downloadsoftware_and_config,software_install_path,log_path],cwd=shell_path)
        #
        #
        # return '开始安装mysql管理软件'

        status_file = log_path + 'is_phpmysqladmin_web_running.status'

        try:

            with open(status_file, 'r') as f:
                status = f.read().rstrip("\n")

                if status == '2':
                    print('已经安装过mysql管理软件')
                    return '已经安装过mysql管理软件,不需要再安装,如果有异常,可以先清除缓存再安装'
                elif status == '1':
                    print('正在执行安装mysql管理软件,请耐心等待一下')

                    return '正在执行安装mysql管理软件,请耐心等待一下'
        except:
            subprocess.Popen(
                ['/bin/sh', project_path + '/shell/diy/phpmysqladmin.sh', downloadsoftware_and_config,
                 software_install_path, log_path],
                cwd=shell_path)

            return '开始安装mysql管理软件'

    else:

        #检查有没有安装过phpmysqladmin
        result = subprocess.check_output(
            ['/bin/sh', project_path + '/shell/diy/check_phpmysqladmin.sh',
              downloadsoftware_and_config,software_install_path],cwd=shell_path)



        # 先转换字节流,python2和python3版本不同导致
        result = result.decode("UTF-8")

        result = result.split('/')[-1]


        # nginx_conf_result = nginx_conf_result.decode("UTF-8")

        return render_template('softwareconfig/phpmysqladmin.html',result=result)






















