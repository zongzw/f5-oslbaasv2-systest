import requests
import json
import sys
import base64
import time
import os
import traceback
import re

class LBaasV2Helper:
    # TODO auth with v2.0
    def __init__(self):

      
        for n in ['OS_AUTH_URL', 'OS_USERNAME', 'OS_PASSWORD', 'OS_PROJECT_NAME', 'OS_PROJECT_DOMAIN_NAME']:
            if os.environ.get(n, None) == None:
                traceback.print_exc()
                raise Exception("environment %s not defined." % n)

        self.os_auth_url = os.environ['OS_AUTH_URL']
        matched = re.match(r'.*://([\d\.]+):\d+.*', self.os_auth_url)
        if not matched:
            raise Exception("invalid OS_AUTH_URL") 
        self.os_host = matched.group(1)
        self.os_project_name = os.environ['OS_PROJECT_NAME']
        self.os_project_domain_name = os.environ['OS_PROJECT_DOMAIN_NAME']
        self.os_username = os.environ['OS_USERNAME']
        self.os_password = os.environ['OS_PASSWORD']
        self.authed_token = self.auth_token()
        self.timestamp = int(time.time())
    
    def auth_token(self):
        
        auth_url = "%s/auth/tokens" % self.os_auth_url
        payload = {
            "auth": {
                "identity": {
                    "methods": [
                        "password"
                    ],
                    "password": {
                        "user": {
                            "name": self.os_username,
                            "domain": {
                                "name": "Default"
                            },
                            "password": self.os_password
                        }
                    }
                },
                "scope": {
                    "project": {
                        "domain": {
                            "name": self.os_project_domain_name
                        },
                        "name": self.os_project_name
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
                return response.headers['X-Subject-Token']
            else:
                print("failed to auth token: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception as e:
            traceback.print_exc()
            raise e


    def get_subnet_id(self, subnet_name):
        subnet_url = "http://%s:9696/v2.0/subnets?fields=id&name=%s" % (self.os_host, subnet_name)

        payload = {}
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
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


    def create_loadbalancer(self, subnet_name):
        lb_create_url = "http://%s:9696/v2.0/lbaas/loadbalancers" % self.os_host

        payload = {
            "loadbalancer": {
                "vip_subnet_id": self.get_subnet_id(subnet_name), 
                "name": "lb-%d" % self.timestamp, 
                "admin_state_up": True
            }
        }
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
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


    def get_loadbalancer(self, loadbalancer_id):
        lb_url = "http://%s:9696/v2.0/lbaas/loadbalancers/%s" % (self.os_host, loadbalancer_id)

        payload  = {}
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
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


    def wait_for_loadbalancer_updated(self, loadbalancer_id):
        max_times = 10
        while max_times > 0:
            lb = self.get_loadbalancer(loadbalancer_id)
            if lb['loadbalancer']['provisioning_status'].startswith("PENDING_"):
                print("waiting for lb %s to be ACTIVE" % loadbalancer_id)
                pass
            else:
                print("lb %s becomes to %s" % (loadbalancer_id, lb['loadbalancer']['provisioning_status']))
                return

            max_times -= 1
            time.sleep(3)

        raise Exception("Timeout for waiting for lb %s ACTIVE" % loadbalancer_id)

    def delete_loadbalancer(self, loadbalancer_id):
        lb_url = "http://%s:9696/v2.0/lbaas/loadbalancers/%s" % (self.os_host, loadbalancer_id)

        payload  = {}
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
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


    def create_listener(self, loadbalancer_id):
        ls_create_url = "http://%s:9696/v2.0/lbaas/listeners" % self.os_host

        payload = {
            "listener": {
                "loadbalancer_id": loadbalancer_id, 
                "protocol_port": 89,
                "protocol": "HTTP"

            }
        }
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
        }
        payload_data = json.dumps(payload)

        try:
            response = requests.request("POST", ls_create_url, headers=headers, data = payload_data)
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                raise Exception("failed to create listener: %d, %s" % (response.status_code, response.text.encode('utf-8')))
        except Exception as e:
            traceback.print_exc()
            raise e


    def get_agents(self, **kwargs):
        agents_url = "http://%s:9696/v2.0/agents" % (self.os_host)

        payload  = {}
        headers = {
            'Content-Type': 'application/json',
            'X-Auth-Token': self.authed_token
        }

        queries = []
        for n in kwargs:
            queries.append('%s=%s' % (n, kwargs[n]))
        
        if queries:
            agents_url = "%s?%s" % (agents_url, '&'.join(queries))

        try:
            response = requests.request("GET", agents_url, headers=headers, data = payload)
            
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                print("failed to get loadbalancer: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception  as e:
            traceback.print_exc()
            raise e


if __name__ == "__main__":
    h = LBaasV2Helper()
    # print(h.authed_token)
    # print(h.get_subnet_id('public_subnet'))
    # lb = h.create_loadbalancer('public_subnet')
    # print(lb)
    # lbid = lb['loadbalancer']['id']
    # print(h.get_loadbalancer(lbid))
    # h.wait_for_loadbalancer_updated(lbid)
    # h.delete_loadbalancer(lbid)

    agents = h.get_agents(binary='f5-oslbaasv2-agent')
    print(json.dumps(agents, indent=2))


