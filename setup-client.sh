#!/bin/bash

set -e

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <env.conf> or $1 not exists"
    exit 1
fi

export workdir=`cd $(dirname $0); pwd`

# sudo to root
echo default | passwd --stdin root

echo >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

setup_proxy

yum install -y epel-release
yum install -y vim wget curl tree tcpdump sshpass
