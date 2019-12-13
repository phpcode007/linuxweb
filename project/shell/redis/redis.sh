#安装php
function installredis()
{
    #写入开始状态码
    echo '1' > $3/is_redis_web_running.status

    sh $1/inityum.sh


  	cd $1

    sha256code=$(sha256sum redis-5.0.7.tar.gz | awk '{print $1}')

	  if [[ $sha256code != '61db74eabf6801f057fd24b590232f2f337d422280fd19486eca03be87d3a82b' ]]
    then
        wget -O redis-5.0.7.tar.gz http://download.redis.io/releases/redis-5.0.7.tar.gz
    else
        echo '不需要再下载redis-5.0.7'
    fi

	  tar -xzf redis-5.0.7.tar.gz

    mkdir -p $2/redis_6379
    \cp -rf redis-5.0.7/* $2/redis_6379


	  cd $2/redis_6379

    make

    mkdir -p $2/redis_6379/data

    sed -i "s/daemonize no/daemonize yes/" $2/redis_6379/redis.conf
#    sed -i "s/supervised no/supervised systemd/" $2/redis_6379/redis.conf
    sed -i "s#dir ./#dir $2/redis_6379/data#" $2/redis_6379/redis.conf

    $2/redis_6379/src/redis-server $2/redis_6379/redis.conf


    sh $1/add_path.sh $2/redis_6379/src

    sed -i '/redis-server/d' /etc/rc.local
    echo "$2/redis_6379/src/redis-server $2/redis_6379/redis.conf" >> /etc/rc.local

#    \cp -rf $1/redis.service  /lib/systemd/system/
#    sed -i "s#redis_path#$2#g" /lib/systemd/system/redis.service

#    systemctl daemon-reload
#    systemctl enable redis
#    systemctl restart redis

    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_redis_web_running.status
      echo 'redis安装完成'
    fi

}

installredis $1 $2 $3