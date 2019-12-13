#!/bin/bash
path_info=$(grep '^PATH=$PATH' /etc/profile)

if [[ ! $path_info ]]
then
    #echo "之前没有添加过path,第一次添加path"
    echo 'PATH=$PATH':"$1" >> /etc/profile
else
    sed -i '/^PATH=$PATH/d' /etc/profile

    #删除相同的路径
    path_info=$(echo $path_info | sed "s#$1##g")

    echo "$path_info":"$1" >> /etc/profile
fi


sed -i 's#:\{2,\}#:#g' /etc/profile

source /etc/profile