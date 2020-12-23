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

# Used by yum
if [ -n "$proxy" ]; then
    export http_proxy=$http_proxy
    export https_proxy=$http_proxy

    # Used by pip
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy
fi

yum install -y epel-release
yum install -y vim wget curl tree tcpdump sshpass
yum install -y python-virtualenv

if [ ! -d $virtualenv_folder ]; then
    virtualenv $virtualenv_folder
fi
source $virtualenv_folder/bin/activate

pip install --upgrade pip
pip --version
pip install python-neutronclient
pip install python-openstackclient

sed -i "/import queue/s/import queue/import Queue as queue/" \
    $virtualenv_folder/lib/python2.7/site-packages/openstack/utils.py \
    $virtualenv_folder/lib/python2.7/site-packages/openstack/cloud/openstackcloud.py

source openrc.sh

if [ ! -f /root/.ssh/id_rsa ]; then
    ssh-keygen -f /root/.ssh/id_rsa -P ""
fi

for n in $neutron_servers; do
    echo $n
    sshpass -p default \
        ssh -o StrictHostKeyChecking=no root@$n \
        "echo `cat /root/.ssh/id_rsa.pub` >> /root/.ssh/authorized_keys"
done
