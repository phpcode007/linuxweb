#!/bin/bash

echo $1
echo $2
echo '获取到的域名是。。。。。。。。。。'
echo $3
#nginx_diy_path=$(echo $3 | sed 's/ //g')





aa="['dsa1dsaf.com','tt2.com']"

xjq=$(echo $aa | sed 's#\[##g' | sed 's#\]##g' | sed "s#'##g" | sed "s#,##g")
echo $xjq

#整理为nginx domain
sed_doamin=$(echo $3 | sed 's#\[##g' | sed 's#\]##g' | sed "s#'##g" | sed "s#, # #g")
#sed_doamin=$(echo $3 | sed 's#\[##g' | sed 's#\]##g' )

#整理为nginx path
sed_path=$(echo $3 | sed 's#\[##g' | sed 's#\]##g' | sed "s#'##g" | sed "s#, ##g")
echo '########################'
echo $sed_doamin
echo '########################'
echo $sed_path

\cp -rf $1/../nginx/nginx_php_fpm.conf $2/nginx/conf/vhost/$sed_path.conf

sed -i "s#nginx_port#80#g" $2/nginx/conf/vhost/$sed_path.conf
sed -i "s#nginx_domain#$sed_doamin#g" $2/nginx/conf/vhost/$sed_path.conf
sed -i "s#nginx_path#$sed_path#g" $2/nginx/conf/vhost/$sed_path.conf

#sed -i 's/nginx_domain/'$3'/g' $2/nginx/conf/vhost/$nginx_diy_path.conf
#sed -i "s#nginx_path#$nginx_diy_path#g" $2/nginx/conf/vhost/$nginx_diy_path.conf

mkdir -p $2/nginx/html/$sed_path

#重启nginx
nginx_running_status=$(pidof nginx)

if [[ ! $nginx_running_status ]]
then
    #防止重启不了,先reload
#    systemctl daemon-reload
    #没有运行nginx,用restart
#    systemctl restart nginx
    /etc/init.d/nginx restart
else
    #防止重启不了,先reload
#    systemctl daemon-reload
#    systemctl reload nginx
    /etc/init.d/nginx reload
fi