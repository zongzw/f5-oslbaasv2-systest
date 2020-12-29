#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <env.conf> or $1 not exists"
    exit 1
fi

source $1
workdir=`cd $(dirname $0); pwd`

source $openrc
python $workdir/deploy.py