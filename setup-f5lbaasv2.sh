#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <env.conf> or $1 not exists"
    exit 1
fi

envfile=$1
source $envfile
workdir=`cd $(dirname $0); pwd`

for n in $rpm_agent $rpm_driver $rpm_f5sdk $rpm_icontrol; do
    bname=`basename $n`
    if [ ! -f $workdir/releases/$bname ]; then
        wget $n -O $workdir/releases/$bname
    fi
done

function reinstall_f5() {
    RPMS=($(rpm -qa | grep ^f5-))
    if [[ ${#RPMS[@]} -gt 0 ]] ; then
        echo "removing existsing f5 packages.."
        rpm -ev ${RPMS[@]}
    fi
    rpm -ivh \
        $workdir/releases/`basename $rpm_f5sdk` \
        $workdir/releases/`basename $rpm_icontrol` \
        $workdir/releases/`basename $rpm_driver` \
        $workdir/releases/`basename $rpm_agent`
}

function reconfig_f5() {
    export RDO_VM_IP=`ifconfig eth0 |grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
    source $openrc

    pip install configparser
    cp $workdir/configs/$vers_agent-f5-openstack-agent.ini /etc/neutron/services/f5/f5-openstack-agent.ini
    
    python $workdir/_config-ini-conf.py
    chown -R neutron:neutron /etc/neutron

    # Restart Service

    systemctl daemon-reload
    echo "systemctl restart neutron-server ..."
    systemctl restart neutron-server
    echo "systemctl enable f5-openstack-agent ..."
    systemctl enable f5-openstack-agent
    echo "systemctl start f5-openstack-agent ..."
    systemctl start f5-openstack-agent

    echo "show status .."
    systemctl status neutron-server
    systemctl status f5-openstack-agent
}

reinstall_f5
reconfig_f5