#安装php
function installphp()
{
    #写入开始状态码
    echo '1' > $3/is_php_web_running.status

    sh $1/inityum.sh


  	cd $1

    sha256code=$(sha256sum php-7.3.12.tar.xz | awk '{print $1}')

	  if [[ $sha256code != 'aafe5e9861ad828860c6af8c88cdc1488314785962328eb1783607c1fdd855df' ]]
    then
        wget -O php-7.3.12.tar.xz https://www.php.net/distributions/php-7.3.12.tar.xz
    else
        echo '不需要再下载php-7.3.12'
    fi

	  tar -xJf php-7.3.12.tar.xz



	  cd php-7.3.12
    ./configure --prefix=$2/php --with-config-file-path=$2/php/etc \
        --enable-mbregex --enable-fpm --enable-mbstring \
        --with-openssl --with-mhash --enable-pcntl  \
        --enable-opcache --disable-fileinfo --with-gd\
        --with-config-file-scan-dir=$2/php/lib/php/extensions/no-debug-non-zts-20180731 \
        --with-pdo-mysql=mysqlnd \
        --with-mysqli=mysqlnd

	  make clean && make && make install

    \cp -rf php.ini-production $2/php/etc/php.ini

    sed -i 's#mysqli.default_socket =#mysqli.default_socket =/tmp/mysql.sock#g' $2/php/etc/php.ini


    mv $2/php/etc/php-fpm.conf.default $2/php/etc/php-fpm.conf
    sed -i 's/;pid/pid/' $2/php/etc/php-fpm.conf

    mv $2/php/etc/php-fpm.d/www.conf.default $2/php/etc/php-fpm.d/www.conf

#    \cp -rf ./sapi/fpm/php-fpm.service /lib/systemd/system
    \cp -rf ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
    sed -i 's/35/3/g' /etc/init.d/php-fpm
    chmod 755 /etc/init.d/php-fpm


    #安装redis扩展
    cd $1


    sha256code=$(sha256sum 5.1.1.tar.gz | awk '{print $1}')

	  if [[ $sha256code != '6b054e1c944f0c415a3489cf6ac94d5423b2b506d8c36ac7a8cdd965a1c07cf9' ]]
    then
#        wget -O php-7.3.12.tar.xz https://www.php.net/distributions/php-7.3.12.tar.xz
        wget -O 5.1.1.tar.gz https://github.com/phpredis/phpredis/archive/5.1.1.tar.gz
    else
        echo '不需要再下载phpredis扩展'
    fi




    tar zxf 5.1.1.tar.gz
    cd phpredis-5.1.1
    
    $2/php/bin/phpize
    ./configure --with-php-config=$2/php/bin/php-config
    make && make install

    \cp -rf $1/redis.ini $2/php/lib/php/extensions/no-debug-non-zts-20180731/

    sh $1/add_path.sh $2/php/bin

    /etc/init.d/php-fpm restart

    sed -i '/php-fpm/d' /etc/rc.local
    echo '/etc/init.d/php-fpm restart' >> /etc/rc.local


#    systemctl daemon-reload
#    systemctl enable php-fpm
#    systemctl restart php-fpm

    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_php_web_running.status
      echo 'php安装完成'
    fi

}

installphp $1 $2 $3