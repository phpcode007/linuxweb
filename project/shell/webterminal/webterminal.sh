#!/bin/bash

function installwebterminal()
{
    #写入开始状态码
    echo '1' > $3/is_webterminal_web_running.status

    #sh $1/inityum.sh

    cd $1


    sha256code=$(sha256sum node-v12.13.1-linux-x64.tar.xz | awk '{print $1}')

    if [[ $sha256code != 'aca06db37589966829b1ef0f163a5859b156a1d8e51b415bf47590f667c30a25' ]]
    then
        wget -O node-v12.13.1-linux-x64.tar.xz wget https://nodejs.org/dist/v12.13.1/node-v12.13.1-linux-x64.tar.xz
    else
        echo '不需要再下载node-v12.13.1-linux-x64'
    fi

    tar -xJf node-v12.13.1-linux-x64.tar.xz

    \cp -rf node-v12.13.1-linux-x64 $2

    sh $1/add_path.sh $2/node-v12.13.1-linux-x64/bin

    export PATH=$PATH:$2/node-v12.13.1-linux-x64/bin

#    $2/node-v12.13.1-linux-x64/bin/npm install -g cnpm --registry=https://registry.npm.taobao.org
#    $2/node-v12.13.1-linux-x64/bin/cnpm install cloudcmd -g
#    $2/node-v12.13.1-linux-x64/bin/cnpm i gritty -g

    #使用华为的npm源
    $2/node-v12.13.1-linux-x64/bin/npm config set registry https://mirrors.huaweicloud.com/repository/npm/
#    $2/node-v12.13.1-linux-x64/bin/npm cache clean -f
    $2/node-v12.13.1-linux-x64/bin/npm --unsafe-perm=true --allow-root install cloudcmd -g

    #为了防止没有找到环境变量，再设置一次
    export PATH=$PATH:$2/node-v12.13.1-linux-x64/bin
    $2/node-v12.13.1-linux-x64/bin/npm --unsafe-perm=true --allow-root install gritty -g


    #读取密码文件的用户名和密码出来
    username=$(sed -n '1p' /var/log/flaskuserpwd.txt)
    password=$(sed -n '2p' /var/log/flaskuserpwd.txt)

    sha256password=$(echo -n $password | sha256sum | awk '{print $1}')

    \cp -rf $1/webterminal.json $1/../webterminal/webterminal.json

    sed -i "s/abc/$username/g" $1/../webterminal/webterminal.json
    sed -i "s/pwd/$sha256password/g" $1/../webterminal/webterminal.json

    $2/node-v12.13.1-linux-x64/bin/cloudcmd -c $1/../webterminal/webterminal.json

    if [[ $? -eq 0 ]]
    then
      #写入结束状态码
      echo '2' > $3/is_webterminal_web_running.status
    fi

}






installwebterminal $1 $2 $3