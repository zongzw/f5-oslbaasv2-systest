import requests
import json
import sys
import base64
import time
import os
import traceback

os_host = os.environ['OS_HOST']
os_project_id = os.environ['OS_PROJECT_ID']
os_username = os.environ['OS_USERNAME']
os_password = os.environ['OS_PASSWORD']
# listener_id = os.environ['LISTENER_ID']
# bigip_credential = os.environ['BIGIP_CREDENTIAL']
# bigip_host = os.environ['BIGIP_HOST']

# the least container count for later tests
# least_container_num = 3
authed_token = None
timestamp = int(time.time())
# http_profile_name = "http_profile_%d" % timestamp


def auth_token():
    global authed_token

    auth_url = "http://%s:35357/v3/auth/tokens" % os_host
    payload = {
        "auth": {
            "identity": {
                "methods": [
                    "password"
                ],
                "password": {
                    "user": {
                        "name": os_username,
                        "domain": {
                            "name": "Default"
                        },
                        "password": os_password
                    }
                }
            },
            "scope": {
                "project": {
                    "id": os_project_id
                }
            }
        }
    }
    headers = {
    'Content-Type': 'application/json'
    }

    payload_data = json.dumps(payload)
    try:
        response = requests.request("POST", auth_url, headers=headers, data = payload_data)

        if int(response.status_code / 200) == 1:
            authed_token = response.headers['X-Subject-Token']
        else:
            print("failed to auth token: %d, %s" % (response.status_code, response.text.encode('utf-8')))
            sys.exit(1)
    except Exception as e:
        traceback.print_exc()
        raise e


def get_subnet_id(subnet_name):
    subnet_url = "http://%s:9696/v2.0/subnets?fields=id&name=%s" % (os_host, subnet_name)

    payload = {}
    headers = {
        'Content-Type': 'application/json',
        'X-Auth-Token': authed_token
    }
    payload_data = json.dumps(payload)

    try:
        response = requests.request("GET", subnet_url, headers=headers, data = payload_data)
        if int(response.status_code / 200) == 1:
            # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
            return json.loads(response.text.encode('utf8'))['subnets'][0]['id']
        else:
            print("failed to get subnet id: %d, %s" % (response.status_code, response.text.encode('utf-8')))
            sys.exit(1)
    except Exception as e:
        traceback.print_exc()
        raise e


def create_loadbalancer(subnet_name):
    lb_create_url = "http://%s:9696/v2.0/lbaas/loadbalancers" % os_host

    payload = {
        "loadbalancer": {
            "vip_subnet_id": get_subnet_id(subnet_name), 
            "name": "lb-%d" % timestamp, 
            "admin_state_up": True
        }
    }
    headers = {
        'Content-Type': 'application/json',
        'X-Auth-Token': authed_token
    }
    payload_data = json.dumps(payload)

    try:
        response = requests.request("POST", lb_create_url, headers=headers, data = payload_data)
        if int(response.status_code / 200) == 1:
            # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
            return json.loads(response.text.encode('utf8'))
        else:
            print("failed to create loadbalancer: %d, %s" % (response.status_code, response.text.encode('utf-8')))
            sys.exit(1)
    except Exception as e:
        traceback.print_exc()
        raise e


def get_loadbalancer(loadbalancer_id):
    lb_url = "http://%s:9696/v2.0/lbaas/loadbalancers/%s" % (os_host, loadbalancer_id)

    payload  = {}
    headers = {
        'Content-Type': 'application/json',
        'X-Auth-Token': authed_token
    }

    try:
        response = requests.request("GET", lb_url, headers=headers, data = payload)
        
        if int(response.status_code / 200) == 1:
            # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
            return json.loads(response.text.encode('utf8'))
        else:
            print("failed to get loadbalancer: %d, %s" % (response.status_code, response.text.encode('utf-8')))
            sys.exit(1)
    except Exception  as e:
        traceback.print_exc()
        raise e


def wait_for_loadbalancer_updated(loadbalancer_id):
    max_times = 10
    while max_times > 0:
        lb = get_loadbalancer(loadbalancer_id)
        if lb['loadbalancer']['provisioning_status'].startswith("PENDING_"):
            max_times -= 1
            time.sleep(1)
        else:
            break


def delete_loadbalancer(loadbalancer_id):
    lb_url = "http://%s:9696/v2.0/lbaas/loadbalancers/%s" % (os_host, loadbalancer_id)

    payload  = {}
    headers = {
        'Content-Type': 'application/json',
        'X-Auth-Token': authed_token
    }

    try:
        response = requests.request("DELETE", lb_url, headers=headers, data = payload)
        
        if int(response.status_code / 200) == 1:
            pass
        else:
            print("failed to delete loadbalancer %s: %d, %s" % (
                loadbalancer_id, response.status_code, response.text.encode('utf-8')))
            sys.exit(1)
    except Exception  as e:
        traceback.print_exc()
        raise e
       
# ============================= main logic =============================

auth_token()
print(authed_token)
lb = create_loadbalancer('public_subnet')
print(lb)
lbid = lb['loadbalancer']['id']
wait_for_loadbalancer_updated(lbid)
print(get_loadbalancer(lbid))
delete_loadbalancer(lbid)
