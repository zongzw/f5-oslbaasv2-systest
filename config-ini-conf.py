import configparser
import os

# ---------------- neutron.conf ----------------

neutron_conf = configparser.ConfigParser()

with open('/etc/neutron/neutron.conf') as fr:
    neutron_conf.readfp(fr)

print(neutron_conf.sections())

neutron_conf.remove_option('service_providers', 'service_provider')
neutron_conf.set('DEFAULT', 'debug', 'True')
neutron_conf['service_auth'] = {
    'auth_url': 'http://%s:35357/v2.0' % os.environ['RDO_VM_IP'],
    'admin_user': 'admin',
    'admin_tenant_name': 'admin',
    'admin_password': os.environ['OS_PASSWORD'],
    'auth_version': '2',
    'insecure': 'True'
}

with open('/etc/neutron/neutron.conf', 'w') as fw:
    neutron_conf.write(fw)

# ---------------- neutron_lbaas.conf ----------------

lbaas_conf = configparser.ConfigParser()

with open('/etc/neutron/neutron_lbaas.conf') as fr:
    lbaas_conf.readfp(fr)

print(lbaas_conf.sections())

lbaas_conf.set('DEFAULT', 'f5_driver_perf_mode', '3')
lbaas_conf.set('service_providers', 'service_provider', 'LOADBALANCERV2:F5Networks:neutron_lbaas.drivers.f5.driver_v2.F5LBaaSV2Driver:default')
lbaas_conf.set('quotas', 'quota_loadbalancer', '-1')
lbaas_conf.set('quotas', 'quota_pool', '-1')

with open('/etc/neutron/neutron_lbaas.conf', 'w') as fw:
    lbaas_conf.write(fw)

# ---------------- f5-openstack-agent.ini ----------------

agent_conf = configparser.ConfigParser()
with open('/etc/neutron/services/f5/f5-openstack-agent.ini') as fr:
    agent_conf.readfp(fr)

print(agent_conf.sections())

agent_conf.set('DEFAULT', 'f5_agent_mode', 'lite')
agent_conf.set('DEFAULT', 'periodic_interval', '120000')
agent_conf.set('DEFAULT', 'debug', 'True')
agent_conf.set('DEFAULT', 'icontrol_hostname', os.environ['__ICONTROL_HOSTNAME__'])
agent_conf.set('DEFAULT', 'icontrol_password', os.environ['__ICONTROL_PASSWORD__'])
agent_conf.set('DEFAULT', 'f5_global_routed_mode', 'False')
agent_conf.set('DEFAULT', 'auth_version', 'v3')
agent_conf.set('DEFAULT', 'os_auth_url', 'http://%s:35357/v3/' % os.environ['RDO_VM_IP'])
agent_conf.set('DEFAULT', 'os_username', 'admin')
agent_conf.set('DEFAULT', 'os_password', os.environ['OS_PASSWORD'])
agent_conf.set('DEFAULT', 'cert_manager', 'f5_openstack_agent.lbaasv2.drivers.bigip.barbican_cert.BarbicanCertManager')

with open('/etc/neutron/services/f5/f5-openstack-agent.ini', 'w') as fw:
    agent_conf.write(fw)
