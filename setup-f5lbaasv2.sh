#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "$0 <env.conf> or $1 not exists"
    exit 1
fi

source $1
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
    cp $workdir/configs/$vers_agent-f5-openstack-agent.ini /etc/neutron/services/f5/f5-openstack-agent.ini

    RDO_VM_IP=`ifconfig eth0 |grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
    controller_host=${RDO_VM_IP:=localhost}

    source $openrc
    
    # ---------------- f5-openstack-agent.ini ----------------
    sed -i \
        "s/^f5_agent_mode = .*/f5_agent_mode = lite/;
        s/^periodic_interval = .*/periodic_interval = 120000/;
        s/^debug = .*/debug = True/;
        s/^icontrol_hostname = .*/icontrol_hostname = $__ICONTROL_HOSTNAME__/;
        s/^icontrol_password = .*/icontrol_password = $__ICONTROL_PASSWORD__/;
        s/^f5_global_routed_mode = .*/f5_global_routed_mode = False/;
        s/^auth_version = .*/auth_version = v3/;
        s/^os_auth_url = .*/os_auth_url = http:\/\/$controller_host:35357\/v3/;
        s/^os_username = .*/os_username = admin/;
        s/^os_password = .*/os_password = $OS_PASSWORD/;
        s/^# cert_manager =/cert_manager =/" \
        /etc/neutron/services/f5/f5-openstack-agent.ini

    # ---------------- neutron_lbaas.conf ----------------
    grep -E "^f5_driver_perf_mode" /etc/neutron/neutron_lbaas.conf > /dev/null
    if [ $? -ne 0 ]; then
        sed -i "/^\[DEFAULT\].*/ a f5_driver_perf_mode = 3" /etc/neutron/neutron_lbaas.conf
    else
        sed -i "/f5_driver_perf_mode/s/f5_driver_perf_mode = .*/f5_driver_perf_mode = 3/" /etc/neutron/neutron_lbaas.conf
    fi

    grep -E "^service_provider = LOADBALANCERV2" /etc/neutron/neutron_lbaas.conf > /dev/null
    if [ $? -ne 0 ]; then
        sed -i "/^#service_provider/ a service_provider = LOADBALANCERV2:F5Networks:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver:default" \
            /etc/neutron/neutron_lbaas.conf
    else
        sed -i "/service_provider = LOADBALANCERV2:/s/service_provider = .*/service_provider = LOADBALANCERV2:F5Networks:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver:default"
            /etc/neutron/neutron_lbaas.conf
    fi
    
    sed -i \
        "s/^#quota_loadbalancer = .*/quota_loadbalancer = -1/;
        s/^#quota_pool = .*/quota_pool = -1/" \
        /etc/neutron/neutron_lbaas.conf

    # ---------------- neutron.conf ----------------
    sed -i \
        "s/^debug=False/debug=True/;
        /^service_provider/ s/^/#/" \
        /etc/neutron/neutron.conf

    # /^#service_plugins=/ a service_plugins=router,neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPluginv2

    grep -E "^\[service_auth\]" /etc/neutron/neutron.conf > /dev/null
    if [ $? -ne 0 ]; then
        echo "
[service_auth]
auth_url = http://${RDO_VM_IP}:35357/v2.0
admin_user = admin
admin_tenant_name = admin
admin_password=${OS_PASSWORD}
auth_version = 2
insecure = true" >> /etc/neutron/neutron.conf
    else
        sed -i \
        "s/^auth_url.*/auth_url = http:\/\/${RDO_VM_IP}:35357\/v2.0/;
        s/^admin_user.*/admin_user = admin/;
        s/admin_tenant_name.*/admin_tenant_name = admin/;
        s/^admin_password.*/admin_password = $OS_PASSWORD/;
        s/^auth_version.*/auth_version = 2/;
        s/^insecure.*/insecure = true/" \
        /etc/neutron/neutron.conf
    fi

    systemctl daemon-reload

    # Restart Service
    systemctl restart neutron-server
    systemctl enable f5-openstack-agent
    systemctl start f5-openstack-agent
}

reinstall_f5
reconfig_f5