# -*- coding: utf-8 -*-
# from project import app
from project import *

# 为了捕捉所有的异常, 我们需要绑定异常的基类 Exception, Flask>1.0
# from werkzeug.exceptions import HTTPException
# import sys



@app.before_request#执行所有装饰器都要执行当前装饰器(简洁版实现同样功能)
def login_required():

    if 'login' in request.path:
        pass
    elif 'register' in request.path:
        pass
    elif 'static' in request.path:
        pass
    elif 'xjq' in request.path:
        pass
    elif 'favicon' in request.path:
        pass
    else:


        user=session.get('user')  #获取用户登录信息
        if not user:                 #没有登录就自动跳转到登录页面去
            return redirect('/login')


        return None




@app.errorhandler(Exception)
def framework_error(e):
    # ApiExcetion
    # HttpException
    # Exception
    if isinstance(e, ApiException):
        return e
    if isinstance(e, HTTPException):
        code = e.code
        msg = e.description
        error_code = 1007
        return ApiException(code=code, msg=msg, error_code=error_code)
    else:
        if not app.config['DEBUG']:
            return ApiException()
        raise e





@app.route('/')
def index():

    #获取外网ip
    public_ip = get_public_ip()

    #获取内网ip
    ips = get_ip()

    #获取负载
    loads = get_load()

    #CPU使用率
    cpuuse = get_cpu()

    #内存使用率
    menerytotalpercent = menery_total_percent()

    #系统版本信息
    systeminfo = system_info()

    #系统持续运行时间
    updatetime = update_time()

    return render_template('index/index.html' ,public_ip=public_ip,ips=ips, loads= loads,cpuuse=cpuuse, menerytotalpercent=menerytotalpercent,
                            systeminfo=systeminfo,updatetime = updatetime)


@app.route('/login',methods=['GET', 'POST'])
def login():

    if request.method == 'POST':

        file_result = []

        #读取账户密码文件出来
        with open('/var/log/flaskuserpwd.txt', 'r') as f:

            for line in f:
                file_result.append(line.strip('\n'))




        # if request.json['username'] == file_result[0] and request.json['password'] == file_result[1]:
        if request.form.get('username') == file_result[0] and request.form.get('password') == file_result[1]:
            session['user'] = file_result[0]
            return redirect('/')

        else:
            flash('账号密码不对,请重新登录')
            return redirect('/login')

    else:
        return render_template('index/login.html')


#退出登录
@app.route('/index_logout')
def index_logout():
    # 移除session
    session.pop('user', None)
    return redirect('/login')




@app.route('/index_info')
def index_info():

    # 磁盘使用率
    disk = psutil.disk_partitions()
    for i in disk:

        print("磁盘：%s   分区格式:%s" % (i.device, i.fstype))
        disk_use = psutil.disk_usage(i.device)
        print("使用了：%sM,空闲：%sM,总共：%sM,使用率\033[1;31;42m%s%%\033[0m," % (
        disk_use.used / 1024 / 1024, disk_use.free / 1024 / 1024, disk_use.total / 1024 / 1024, disk_use.percent))


    return render_template('index/index_info.html',if_list=if_list,update_time=update_time)


#获取外网ip地址
def get_public_ip():

    # ip_cache_path = '/var/log/publicip.txt'

    try:
        if os.path.exists(ip_cache_path):

            #判断ip缓存文件是否过期

            # 获取当前时间
            today = datetime.datetime.now()
            # 计算偏移量,前3天
            offset = datetime.timedelta(days=-1)
            # 获取想要的日期的时间,即前3天时间
            re_date = (today + offset)
            # 前3天时间转换为时间戳
            re_date_unix = time.mktime(re_date.timetuple())



            file_time = os.path.getmtime(ip_cache_path)  # 文件修改时间
            timeArray = time.localtime(file_time)  # 时间戳->结构化时间
            otherStyleTime = time.strftime("%Y-%m-%d %H:%M:%S", timeArray)  # 格式化时间

            if file_time <= re_date_unix:
                os.remove(ip_cache_path)
            else:
                pass


            f = open(ip_cache_path, 'r')
            result = f.read()

            return result


        else:

            result = requests.get('http://ifconfig.co/ip', timeout=1)

            f = open(ip_cache_path, 'w')
            f.write(result.text)
            f.close()


    except Exception as e:
        print('except:', e)

        return '0.0.0.0'


#获取内网ip地址
def get_ip():
    # get_public_ip()

    #内网ip
    if_list = []
    try:
        addrs = psutil.net_if_addrs()
        for _, net_card_info in addrs.items():
            for each_ip in net_card_info:
                if each_ip.family == socket.AF_INET and each_ip.address != '127.0.0.1': #linux socket.AF_INET=2
                    if_list.append(each_ip.address)
    except:
        if_list.append('127.0.0.1')

    return if_list

#负载状态
def get_load():
    loadavg = psutil.getloadavg()

    # cpucount = psutil.cpu_count()
    # load = [x / psutil.cpu_count() * 100 for x in psutil.getloadavg()]

    return loadavg


#CPU使用率
def get_cpu():

    return (str)(psutil.cpu_percent(0)) + '%'


#内存使用率
def menery_total_percent():
    return (str)(psutil.virtual_memory().percent) + '%'

#系统版本信息
def system_info():
    return platform.platform()

#系统持续运行时间辅助函数
def subtime(date1, date2):
    date1 = datetime.datetime.strptime(date1, "%Y-%m-%d %H:%M:%S")
    date2 = datetime.datetime.strptime(date2, "%Y-%m-%d %H:%M:%S")

    return date2 - date1

#系统持续运行时间
def update_time():

    boot_time = psutil.boot_time()
    boot_time = datetime.datetime.fromtimestamp(psutil.boot_time()).strftime("%Y-%m-%d %H:%M:%S")

    nowdate = datetime.datetime.now()  # 获取当前时间
    nowdate = nowdate.strftime("%Y-%m-%d %H:%M:%S")  # 当前时间转换为指定字符串格式
    updatetime = subtime(boot_time,nowdate)  # nowdate > date2

    return updatetime