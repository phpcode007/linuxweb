#安装php
function installmysql()
{
    #写入开始状态码
    echo '1' > $3/is_mysql_web_running.status

    sh $1/inityum.sh


  	cd $1

    sha256code=$(sha256sum mysql-boost-5.7.28.tar.gz | awk '{print $1}')

	  if [[ $sha256code != 'f16399315212117c08f9bdf8a0d682728b2ce82d691bcfbf25a770f413b6f2da' ]]
    then
        wget -O mysql-boost-5.7.28.tar.gz https://cdn.mysql.com//Downloads/MySQL-5.7/mysql-boost-5.7.28.tar.gz
    else
        echo '不需要再下载mysql-boost-5.7.28'
    fi

    groupadd mysql
    useradd -r -g mysql -s /bin/false mysql

	  tar -xzf mysql-boost-5.7.28.tar.gz

	  cd mysql-5.7.28

    mkdir bld
    cd bld
    cmake .. -DWITH_BOOST=../boost \
        -DCMAKE_INSTALL_PREFIX=$2/mysql \
        -DDEFAULT_CHARSET=utf8 \
        -DDEFAULT_COLLATION=utf8_general_ci \
        -DEXTRA_CHARSETS=all

    make
    make install

    \cp -rf support-files/mysql.server /etc/init.d/mysqld
    chmod 755 /etc/init.d/mysqld

    \cp -rf $1/my.cnf /etc/my.cnf
    sed -i "s#mysqlbasedir#$2/mysql#g" /etc/my.cnf

    cd $2/mysql

    mkdir -p data
    chown mysql:mysql data
    chmod 750 data

    bin/mysqld --initialize --user=mysql --basedir=$2/mysql --datadir=$2/mysql/data &>> $2/mysql/user.txt

    bin/mysql_ssl_rsa_setup --datadir=$2/mysql/data

    /etc/init.d/mysqld restart

    sh $1/add_path.sh $2/mysql/bin

    sed -i '/mysqld/d' /etc/rc.local
    echo '/etc/init.d/mysqld restart' >> /etc/rc.local


    #mysql限定第一次登录需要修改密码
    mysqlpassword=$(grep password $2/mysql/user.txt | awk '{print $NF}')

    $2/mysql/bin/mysql -uroot -p$mysqlpassword --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$mysqlpassword' PASSWORD EXPIRE NEVER;"



    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_mysql_web_running.status
      echo 'mysql安装完成'
    fi

}

installmysql $1 $2 $3