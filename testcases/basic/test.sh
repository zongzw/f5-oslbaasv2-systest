#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <env.conf> or $1 not exists"
    exit 1
fi

source $1
workdir=`cd $(dirname $0); pwd`
    
export OS_HOST=`ifconfig eth0 |grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
source $openrc
export OS_PROJECT_ID=$(openstack project show ${OS_PROJECT_NAME} | awk '$2 == "id" { print $4 }')
python deploy.py