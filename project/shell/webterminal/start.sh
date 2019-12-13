#!/bin/bash

function startwebterminal()
{

    cd $1

    export PATH=$PATH:$2/node-v12.13.1-linux-x64/bin

    if [[ -f $2/node-v12.13.1-linux-x64/bin/cloudcmd ]]
    then
      $2/node-v12.13.1-linux-x64/bin/cloudcmd -c $1/../webterminal/webterminal.json
    fi
}

startwebterminal $1 $2


