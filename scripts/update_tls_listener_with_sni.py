import os
import sys
import json

fp = os.path.abspath(__file__)

sys.path.append(os.path.join(os.path.dirname(fp), './tools'))
from libs import lbaasv2_helper

helper = lbaasv2_helper.LBaasV2Helper()

if len(sys.argv) < 3:
    print("invalid input, should be <listener_id> <default_tls_href> [sni_hrefs]")
    sys.exit(1)

listener_id = sys.argv[1]
default_tls_href = sys.argv[2]
sni_hrefs = sys.argv[3:]

updated = helper.update_listener_with_tls(listener_id, default_tls_href, sni_hrefs)

print(json.dumps(updated))