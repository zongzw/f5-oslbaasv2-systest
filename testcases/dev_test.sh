#!/bin/bash

workdir=`cd $(dirname $0); pwd`
set -x
ansible-playbook -i $workdir/../conf.d/group_and_hosts-osp -e @$workdir/../conf.d/vars-ruijie-private-4.5.1.yml $workdir/dev_test.yml $@

cat > /dev/null <<  EOF
{
    "10.250.2.211": {
        "admin_password": "P@ssw0rd123",
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "bigips"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.2.211",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "root_password": "P@ssw0rd123",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.2.212": {
        "admin_password": "P@ssw0rd123",
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "bigips"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.2.212",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "root_password": "P@ssw0rd123",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.23.54": {
        "agent_services": "f5-openstack-agent-CORE,f5-openstack-agent-DMZ",
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "neutron_servers"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.23.54",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "openrc": "/home/heat-admin/overcloudrc",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "test_env": "osp",
        "test_subnet": "vlan30_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.23.59": {
        "agent_services": "f5-openstack-agent-CORE,f5-openstack-agent-DMZ",
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "neutron_servers"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.23.59",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "openrc": "/home/heat-admin/overcloudrc",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "test_env": "osp",
        "test_subnet": "vlan30_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.23.60": {
        "agent_services": "f5-openstack-agent-CORE,f5-openstack-agent-DMZ",
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "neutron_servers"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.23.60",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "openrc": "/home/heat-admin/overcloudrc",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "test_env": "osp",
        "test_subnet": "vlan30_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.26.13": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan26"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.26.13",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan26_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.26.7": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan26"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.26.7",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan26_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.26.8": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan26"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.26.8",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan26_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.28.14": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan28"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.28.14",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan28_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.28.5": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan28"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.28.5",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan28_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    },
    "10.250.28.6": {
        "ansible_check_mode": "False",
        "ansible_diff_mode": "False",
        "ansible_facts": {},
        "ansible_forks": 5,
        "ansible_inventory_sources": [
            "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp"
        ],
        "ansible_playbook_python": "/usr/bin/python2",
        "ansible_run_tags": [
            "all"
        ],
        "ansible_skip_tags": [],
        "ansible_verbosity": 0,
        "ansible_version": {
            "full": "2.9.15",
            "major": 2,
            "minor": 9,
            "revision": 15,
            "string": "2.9.15"
        },
        "download_prefix": "http://10.250.11.185/f5-packages",
        "group_names": [
            "backend_servers",
            "servers_vlan28"
        ],
        "groups": {
            "all": [
                "10.250.2.211",
                "10.250.2.212",
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54",
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "backend_servers": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8",
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "bigips": [
                "10.250.2.211",
                "10.250.2.212"
            ],
            "neutron_servers": [
                "10.250.23.60",
                "10.250.23.59",
                "10.250.23.54"
            ],
            "servers_vlan26": [
                "10.250.26.13",
                "10.250.26.7",
                "10.250.26.8"
            ],
            "servers_vlan28": [
                "10.250.28.14",
                "10.250.28.5",
                "10.250.28.6"
            ],
            "ungrouped": []
        },
        "inventory_dir": "/root/f5-oslbaasv2-systest/conf.d",
        "inventory_file": "/root/f5-oslbaasv2-systest/conf.d/group_and_hosts-osp",
        "inventory_hostname": "10.250.28.6",
        "inventory_hostname_short": "10",
        "omit": "__omit_place_holder__2ed4fea494022e3c2fff45aeec4a7f6e764e67d4",
        "playbook_dir": "/root/f5-oslbaasv2-systest/playbooks",
        "subnet": "vlan28_subnet",
        "testcases": [
            {
                "name": "basic"
            },
            {
                "client_ca_path": "../kps/client-ca.cert",
                "name": "mtls"
            }
        ],
        "versions": {
            "agent": "9.9.1",
            "driver": "212.5.1",
            "f5sdk": "3.0.11.1",
            "icontrol": "1.3.9"
        }
    }
}

EOF