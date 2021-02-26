import os
import sys
import datetime
import time

fp = os.path.abspath(__file__)

sys.path.append(os.path.join(os.path.dirname(fp), './tools'))
from libs import lbaasv2_helper

origdt = {}

l = lbaasv2_helper.LBaasV2Helper()

retries = 100
delay = 6
while retries > 0:
    time.sleep(delay)
    retries = retries - 1

    agents = l.get_agents(binary='f5-oslbaasv2-agent')
    live_agents = filter(lambda a: a['alive'], agents['agents'])
    if len(live_agents) == 0:
        print('live agents found: 0')
        continue

    done = True
    for a in live_agents:
        id = a['id']
        print("agent %s timestamp: %s, alive: %s, admin_state_up: %s"
            % (id, a['heartbeat_timestamp'], a['alive'], a['admin_state_up']))
        if not id in origdt:
            origdt[id] = a['heartbeat_timestamp']
        if a['heartbeat_timestamp'] <= origdt[id]:
            done = False

    if done:
        print("agents meet the heartbeat_timestamp.")
        sys.exit(0)

print("timeout for waiting for new heartbeat.")
sys.exit(1)