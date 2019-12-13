#!/bin/bash

#grep -h server_name $2/nginx/conf/vhost/*.conf | awk '{print $2}' | sed -e "s#\r##" -e "s#;##g"  | xargs | tr "\n" " "
grep -h server_name $2/nginx/conf/vhost/*.conf | awk -F'server_name' '{print $2}' | sed  's/;//g'