#!/bin/bash

if [ $# -lt 2 ]; then
    echo "$0 <dev|lab> <public|private>"
    exit 1
fi 

workdir=`cd $(dirname $0); pwd`/..

ifile=$1

if [ "$2" = "public" ]; then
    efile=$workdir/conf.d/vars-ruijie-public-2021.01.08.yml
elif [ "$2" = "private" ]; then
    efile=$workdir/conf.d/vars-cmcc-private-2021.01.08.yml
else
    echo "not support. $2"
    exit 1
fi

if [ ! -f $efile ]; then
    echo "$efile not found."
    exit 1
fi

shift; shift
set -x 
ansible-playbook -i $workdir/conf.d/group_and_hosts-$ifile -e @$efile $workdir/playbooks/run-testcases.yml $@
