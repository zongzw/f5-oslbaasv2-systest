import os
import sys

fp = os.path.abspath(__file__)

sys.path.append(os.path.join(os.path.dirname(fp), '../../tools'))
import libs

h = libs.lbaasv2_helper.LBaasV2Helper()
print(h.authed_token)
print(h.get_subnet_id('public_subnet'))
lb = h.create_loadbalancer('public_subnet')
print(lb)
lbid = lb['loadbalancer']['id']
print(h.get_loadbalancer(lbid))
h.wait_for_loadbalancer_updated(lbid)
h.delete_loadbalancer(lbid)
