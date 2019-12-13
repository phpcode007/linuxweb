#!/bin/bash

phpmysqladmin=$(find $2/nginx/html/ -name *.phpmysqladmin.com)

if [[ ! $phpmysqladmin ]]
then
    echo "0"
else
    echo $phpmysqladmin
fi