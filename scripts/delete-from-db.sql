delete from lbaas_members;

delete from lbaas_l7rules;
delete from lbaas_l7policies;

delete from lbaas_sni;
delete from lbaas_listeners;
delete from lbaas_sessionpersistences;

delete from lbaas_pools;
delete from lbaas_healthmonitors;

delete from lbaas_loadbalancer_statistics;
delete from lbaas_loadbalancers;
delete from lbaas_loadbalanceragentbindings;

delete from ports where device_owner in ('neutron:LOADBALANCERV2', 'network:f5lbaasv2', 'F5:lbaasv2');

delete from ipamallocations where ip_address not in (select ip_address from ipallocations);