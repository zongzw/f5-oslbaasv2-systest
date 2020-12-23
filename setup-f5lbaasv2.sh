#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <openrc.sh> or $1 not exists"
    exit 1
fi

source $1

export workdir=`cd $(dirname $0); pwd`
source $openrc

for n in $rpm_agent $rpm_driver $rpm_f5sdk $rpm_icontrolrest; do
    bname=`basename $n`
    if [ ! -f $workdir/releases/$bname ]; then
        wget $n -O $workdir/releases/$bname
    fi
done