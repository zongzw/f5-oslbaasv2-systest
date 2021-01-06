#!/bin/bash

cat << EOF > /etc/environment
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOF
source /etc/environment

echo "deltarpm=0" >> /etc/yum.conf

yum install yum-utils -y
yum install -y https://repos.fedorapeople.org/repos/openstack/EOL/openstack-pike/rdo-release-pike-1.noarch.rpm
yum-config-manager --quiet --save --setopt=openstack-pike.baseurl=http://vault.centos.org/7.6.1810/cloud/x86_64/openstack-pike/ >/dev/null

systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network

yum install -y openstack-packstack python-pip
yum install -y qemu-kvm libvirt libvirt-client virt-install

systemctl start libvirtd
systemctl enable libvirtd

keystone_admin_password=admin
neutron_db_password=neutrondb_password
mariadb_password=mariadb_password

sudo packstack \
  --os-glance-install=y \
  --os-cinder-install=n \
  --os-manila-install=n \
  --os-swift-install=n \
  --os-ceilometer-install=n \
  --os-sahara-install=n \
  --os-trove-install=n \
  --os-ironic-install=n \
  --os-neutron-lbaas-install=y \
  --mariadb-pw=$mariadb_password \
  --os-neutron-db-password=$neutron_db_password \
  --keystone-admin-passwd=$keystone_admin_password \
  --allinone


# chmod o+rx /var/log/neutron
# yum install -y jq patch


# echo "Enable UDP protocol for listener"
# DB_CONN=$(cat /etc/neutron/neutron.conf | grep "^connection=mysql")
# DB_USER=$(echo ${DB_CONN} | cut -d/ -f3 | cut -d@ -f1 | cut -d: -f1)
# DB_PASS=$(echo ${DB_CONN} | cut -d/ -f3 | cut -d@ -f1 | cut -d: -f2)

# echo "alter table lbaas_listeners modify column protocol enum('HTTP','HTTPS','TCP','UDP','TERMINATED_HTTPS','FTP');" | \
#   mysql --user=${DB_USER} --password=${DB_PASS} neutron

# patch -N /usr/lib/python2.7/site-packages/neutron_lbaas/services/loadbalancer/constants.py /stack/patch/constants.py.diff || true
# patch -N /usr/lib/python2.7/site-packages/neutronclient/neutron/v2_0/lb/v2/listener.py /stack/patch/listener.py.diff || true

# source /root/keystonerc_admin
# echo export OS_PROJECT_ID=$(openstack project show admin | awk '$2 == "id" { print $4 }') >> /root/keystonerc_admin
# echo export OS_NEUTRON_URL=$(openstack endpoint list | awk '$6 == "neutron" && $12 == "public" {print $14}') >> /root/keystonerc_admin
