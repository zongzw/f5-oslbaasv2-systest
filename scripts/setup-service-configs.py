#!/usr/bin/python

import configparser
import os
import re
import time

if not 'service_providers' in os.environ:
    raise Exception("No 'service_providers' defined.")

for n in os.environ:
    print("%20s: %s" % (n, os.environ[n]))

def update_config(configpath, updatedpath):
    conf = configparser.ConfigParser()
    conf_upd = configparser.ConfigParser()

    with open(configpath) as fr:
        conf.readfp(fr)
    with open(updatedpath) as fr:
        conf_upd.readfp(fr)

    for k in conf_upd.defaults().keys():
        if conf_upd.defaults()[k] == "DELETE_ME":
            if k in conf['DEFAULT']:
                del conf['DEFAULT'][k]
        else:
            conf['DEFAULT'][k] = conf_upd['DEFAULT'][k]

    for section in conf_upd.sections():
        for option in conf_upd.options(section):
            if option.upper() == 'DELETE_ME':
                if conf.has_section(section):
                    conf.remove_section(section)
                break
            if conf_upd.get(section, option).upper() == 'DELETE_ME':
                if conf.has_section(section) and conf.has_option(option):
                    conf.remove_option(section, option)
            else:
                conf.set(section, option, conf_upd.get(section, option))

    with open(configpath, 'w') as fw:
        conf.write(fw)

print("Configure /etc/neutron/neutron.conf")
update_config('/etc/neutron/neutron.conf', '/tmp/neutron.conf')

print("Configure /etc/neutron/neutron_lbaas.conf")
update_config('/etc/neutron/neutron_lbaas.conf', '/tmp/neutron_lbaas.conf')

for provider in os.environ['service_providers'].split(','):
    print("Configure /etc/neutron/services/f5/f5-openstack-agent-%s.ini" % provider)
    update_config('/etc/neutron/services/f5/f5-openstack-agent-%s.ini' % provider, '/tmp/f5-openstack-agent-%s.ini' % provider)

providers_strs = ['[service_providers]']

for i, provider in enumerate(os.environ['service_providers'].split(',')):
    if i == 0:
        providers_strs.append('service_provider=LOADBALANCERV2:%s:neutron_lbaas.drivers.f5.v2_%s.%s:default' % (provider, provider, provider))
    else:
        providers_strs.append('service_provider=LOADBALANCERV2:%s:neutron_lbaas.drivers.f5.v2_%s.%s' % (provider, provider, provider))

with open('/etc/neutron/neutron_lbaas_service_providers.conf', 'w') as fw:
    fw.write('\n'.join(providers_strs))
