#安装nginx
function installnginx()
{
    #写入开始状态码
    echo '1' > $3/is_nginx_web_running.status

    sh $1/inityum.sh

    cd $1


    sha256code=$(sha256sum nginx-1.16.1.tar.gz | awk '{print $1}')

    if [[ $sha256code != 'f11c2a6dd1d3515736f0324857957db2de98be862461b5a542a3ac6188dbe32b' ]]
    then
        wget -O nginx-1.16.1.tar.gz https://nginx.org/download/nginx-1.16.1.tar.gz
    else
        echo '不需要再下载nginx'
    fi

    tar zxf nginx-1.16.1.tar.gz
    cd nginx-1.16.1
    groupadd www
    useradd -g www www
    ./configure --prefix=$2/nginx --with-http_ssl_module --with-http_realip_module \
        --with-http_gzip_static_module --with-http_stub_status_module  --user=www --group=www --with-stream

    make && make install

    \cp -rf $1/nginx.conf $2/nginx/conf/

    cpu_info=$(cat /proc/cpuinfo |grep -c "cores")

    sed -i "s#nginxinstallpath#$2#g" $2/nginx/conf/nginx.conf
    sed -i "s#cpucores#$cpu_info#g" $2/nginx/conf/nginx.conf

#    \cp -rf $1/nginx.service  /lib/systemd/system/
#    sed -i "s#nginxinstallpath#$2#g" /lib/systemd/system/nginx.service

    mkdir -p $2/nginx/conf/vhost
    mkdir -p $2/nginx/conf/socket

    \cp -rf $1/nginx /etc/init.d/nginx
    sed -i "s#nginx_path#$2/nginx/sbin/nginx#g" /etc/init.d/nginx
    chmod 755 /etc/init.d/nginx

    /etc/init.d/nginx restart

    sh $1/add_path.sh $2/nginx/sbin


    sed -i '/nginx/d' /etc/rc.local
    echo '/etc/init.d/nginx restart' >> /etc/rc.local

#    systemctl daemon-reload
#    systemctl enable nginx
#    systemctl restart nginx

    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_nginx_web_running.status
      echo 'nginx安装完成'
    fi
}

installnginx $1 $2 $3