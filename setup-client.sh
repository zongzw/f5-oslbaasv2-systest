#!/bin/bash

set -e

workdir=`cd $(dirname $0); pwd`

# sudo to root
echo default | passwd --stdin root

echo >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

echo
echo "  Use $workdir/proxy.sh to setup proxy for faster installation."
sleep 1
echo 

yum install -y epel-release
yum install -y vim wget curl tree tcpdump sshpass git
