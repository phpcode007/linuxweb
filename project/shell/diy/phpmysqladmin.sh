#!/bin/bash


#先判断之前有没有安装过一个随机域名的phpmysqladmin
random_phpmysqladmin=$(ls -Shl $3/*.phpmysqladmin.com1)

#再决断有没有那个phpmysqladmin目录，因为有可能在网站配置那里被删除

#echo $random_phpmysqladmin
#写入开始状态码
echo '1' > $3/is_phpmysqladmin_web_running.status


if [[ ! $random_phpmysqladmin && ! -d $2/nginx/html/*.phpmysqladmin.com ]]
then

    sha256code=$(sha256sum phpMyAdmin-4.9.2-all-languages.zip | awk '{print $1}')

    if [[ $sha256code != '82c2bb365804168f61d32d4bf7a00afeaf2509aaedd7e79433c705e67fa0a4ca' ]]
    then
        wget -O phpMyAdmin-4.9.2-all-languages.zip https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.zip
    else
        echo '不需要再下载phpMyAdmin-4.9.2-all-languages'
    fi

    unzip -o phpMyAdmin-4.9.2-all-languages.zip

    randomchar=$(date +%s%N | md5sum | head -c 10)

    echo "$randomchar" >> $3/"$randomchar".phpmysqladmin.com


    sh $1/../nginx/addweb.sh $1 $2 "$randomchar".phpmysqladmin.com

    \cp -rf phpMyAdmin-4.9.2-all-languages/*  $2/nginx/html/"$randomchar".phpmysqladmin.com

    mkdir -p $2/nginx/html/"$randomchar".phpmysqladmin.com/tmp
    chmod -R 777 $2/nginx/html/"$randomchar".phpmysqladmin.com/tmp

    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_phpmysqladmin_web_running.status
    fi


else
    echo "$random_phpmysqladmin 的phpmysqladmin已经创建"
fi


