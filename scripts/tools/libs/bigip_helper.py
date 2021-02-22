import os
import base64
import requests
import sys
import json

class BigipHelper:
    def __init__(self, hostname, admin_password):
        self.authorization = "%s" % base64.b64encode(
            'admin:%s' % admin_password)
        self.bigip_hostname = hostname

    def get_virtual(self, vs='', partition='Common'):
        full_path = "~%s~%s" % (partition, vs) if vs != '' else ''
        virtual_url = "https://%s/mgmt/tm/ltm/virtual/%s?expandSubcollections=true" % (
            self.bigip_hostname, full_path)

        payload = {}
        headers = {
            'content-type': 'application/json',
            'Authorization': 'Basic %s' % self.authorization
        }

        try:
            response = requests.request("GET", virtual_url, verify=False, headers=headers, data = payload)
            
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                print("failed to get bigip virtual: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception  as e:
            raise e

    def get_ftp_profile(self, profile_name, partition='Common'): 
        virtual_url = "https://%s/mgmt/tm/ltm/profile/ftp/~%s~%s" % (
            self.bigip_hostname, partition, profile_name)

        payload = {}
        headers = {
            'content-type': 'application/json',
            'Authorization': 'Basic %s' % self.authorization
        }

        try:
            response = requests.request("GET", virtual_url, verify=False, headers=headers, data = payload)
            
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                print("failed to get bigip ftp profile: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception  as e:
            raise e

    def validate_as3(self):

        as3_url = "https://%s/mgmt/shared/appsvcs/info" % self.bigip_hostname

        payload={}
        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Basic %s' % self.authorization
        }

        try:
            response = requests.request("GET", as3_url, verify=False, headers=headers, data = payload)
            
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                print("failed to get as3 info: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception  as e:
            raise e

    def clean_all_partitions(self):

        declare_url = "https://%s/mgmt/shared/appsvcs/declare" % self.bigip_hostname

        payload={}
        headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Basic %s' % self.authorization
        }
        try:
            response = requests.request("DELETE", declare_url, verify=False, headers=headers, data = payload)
            
            if int(response.status_code / 200) == 1:
                # print(json.dumps(json.loads(response.text.encode('utf8')), indent=2))
                return json.loads(response.text.encode('utf8'))
            else:
                print("failed to delete all partitions: %d, %s" % (response.status_code, response.text.encode('utf-8')))
                sys.exit(1)
        except Exception  as e:
            raise e

    def get_all_partitions(self):
        pass
    

if __name__ == "__main__":
    # os.environ['bigip_admin_password'] = 'P@ssw0rd123'
    # os.environ['bigip_hostname'] = '10.250.2.211'
    h = BigipHelper('10.250.2.211', 'P@ssw0rd123')
    # print(h.get_virtual())
    # jd = json.dumps(h.get_virtual('CORE_7e1d7b36-be14-43bd-8ae7-537664d35362', 'CORE_94f2338bf383405db151c4784c0e358c'))
    # # print(h.validate_as3())
    # print(jd)

    jd = json.dumps(h.get_ftp_profile('ftp_profile_7e1d7b36-be14-43bd-8ae7-537664d35362', 'CORE_94f2338bf383405db151c4784c0e358c'))
    # print(h.clean_all_partitions())
    print(jd)