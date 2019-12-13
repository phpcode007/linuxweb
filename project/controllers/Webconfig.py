# -*- coding: utf-8 -*-

from project import *
from project.forms.CheckParams import AddWebForm

@app.route('/webconfig')
def webconfig():

    #先判断有没有安装nginx
    result = subprocess.check_output(
        ['/bin/sh', project_path + '/shell/nginx/check_nginx_status.sh', downloadsoftware_and_config,
         software_install_path],cwd=shell_path)

    #读取nginx配置文件
    nginx_conf_result = subprocess.check_output(
        ['/bin/sh', project_path + '/shell/nginx/show_nginx_conf.sh', downloadsoftware_and_config,
         software_install_path],cwd=shell_path)

    #先转换字节流,python2和python3版本不同导致
    result = result.decode("UTF-8")
    nginx_conf_result = nginx_conf_result.decode("UTF-8")


    if "com" not in nginx_conf_result:
        nginx_conf_result_split = ""
    else:
        nginx_conf_result_split = nginx_conf_result.split('\n')
        #删除最后一个\n
        nginx_conf_result_split.pop()

        # 生成表达式去除空格和字符串前后空格
        nginx_conf_result_split = [x.strip() for x in nginx_conf_result_split if x.strip() != '']



    # result = result.decode("UTF-8")

    return render_template('webconfig/index.html',result=result,nginx_conf_result=nginx_conf_result_split)

@app.route('/webconfig/addweb',methods=['GET', 'POST'])
def addweb():

    if request.method == 'POST':

        nginx_domain = request.json['nginx_domain']

        form = AddWebForm.from_json(request.json)  # <-- This line right here

        if form.validate():
            print('验证成功')
        else:
            print('验证失败')
            jstr = json.dumps(form.errors, ensure_ascii=False)
            return jstr;
            # return str(form.errors)



        #暂时先放到nginx路径下，等有时间再做选择路径
        nginx_path = '../'
        nginx_port = "80"



        # 这里主要是由于传到shell的参数，不是一行，会导致sed更改不了，先在这里处理完再传给shell
        # 先去重复

        #expected str, bytes or os.PathLike object, not list
        #python3会提示转换不了，暂时的解决方法是先把整个list传给shell,shell自己再处理

        list_nginx_domain = list(set(nginx_domain.split('\n')))


        subprocess.Popen(['/bin/sh',project_path + '/shell/nginx/addweb.sh',downloadsoftware_and_config,software_install_path,str(list_nginx_domain),nginx_path,nginx_port],cwd=shell_path)


        return '添加网站成功'

    else:
        return render_template('webconfig/addweb.html')

















#删除网站
@app.route('/webconfig/delete',methods=['GET', 'POST'])
def delete():

    if request.method == 'POST':

        delete_nginx_domain = request.json['delete_nginx_domain']


        shell_nginx_domain = delete_nginx_domain.replace(' ', '')

        subprocess.Popen(['/bin/sh',project_path + '/shell/nginx/deleteweb.sh',downloadsoftware_and_config,software_install_path,shell_nginx_domain],cwd=shell_path)


        return '删除网站成功'

    # else:
    #     return render_template('webconfig/addweb.html')












