#!/bin/bash

publicip=$(curl -s  http://ip.taobao.com/service/getIpInfo2.php?ip=myip | awk -F"ip" '{print $2}' | awk -F'"' '{print $3}')

if