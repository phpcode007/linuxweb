#!/bin/bash

echo 'shell 脚本'
echo $1
echo $2
echo $3


rm -rf $2/nginx/conf/vhost/$3.conf

rm -rf  $2/nginx/html/$3



#\cp -rf $1/../nginx/nginx_php_fpm.conf $2/nginx/conf/vhost/$nginx_diy_path.conf
#
#sed -i "s#nginx_port#80#g" $2/nginx/conf/vhost/$nginx_diy_path.conf
#sed -i "s/nginx_domain/$6/g" $2/nginx/conf/vhost/$nginx_diy_path.conf
##sed -i 's/nginx_domain/'$3'/g' $2/nginx/conf/vhost/$nginx_diy_path.conf
#sed -i "s#nginx_path#$nginx_diy_path#g" $2/nginx/conf/vhost/$nginx_diy_path.conf

#mkdir -p $2/nginx/html/$nginx_diy_path

#重启nginx
nginx_running_status=$(pidof nginx)

if [[ ! $nginx_running_status ]]
then
    #防止重启不了,先reload
#    systemctl daemon-reload
#    #没有运行nginx,用restart
#    systemctl restart nginx
    /etc/init.d/nginx restart
else
    #防止重启不了,先reload
#    systemctl daemon-reload
#    systemctl reload nginx
    /etc/init.d/nginx reload
fi