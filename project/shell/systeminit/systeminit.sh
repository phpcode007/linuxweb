#!/bin/bash




#创建日志和状态目录
mkdir -p $3

#写入开始状态码
echo '1' > $3/is_systeminit_web_running.status

sh $1/inityum.sh

#初始化系统
function initcentos()
{
    chmod +x /etc/rc.d/rc.local

    #如果已经执行过一次，不会再执行初始化系统
    if [ ! -f "$3/initok" ]
    then
        touch $3/initok

        mv /bin/vi /bin/vi.bak
        ln -s /usr/bin/vim /bin/vi

        #优化一些基本配置
        #关闭IPv6
        #禁止selinux
        #初始化sshd
        #关闭所有服务和防火墙，只保留ssh
        #设置定时更新系统时间
        sh $1/network.sh

        #设置系统文件最大打开数为65535
        #优化系统tcp连接参数
        sh $1/tuning.sh
    else
        echo '已经执行过一次,不需要再初始化'
    fi

}


#上面是定义函数，这里才是执行，initcentos默认执行,其它的安装按实际需要安装即可
initcentos $1 $2 $3

if [[ $? -eq 0 ]]
then
  #写入结束状态码
  echo '2' > $3/is_systeminit_web_running.status
fi

