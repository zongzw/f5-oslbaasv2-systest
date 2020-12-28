import os
import base64
import requests
import sys

class BigipHelper:
    def __init__(self):
        for n in ['bigip_admin_password', 'bigip_hostname']:
            if os.environ.get(n, None) == None:
                raise Exception("Missing environment: %s" % n)

        self.authorization = "%s" % base64.b64encode(
            'admin:%s' % os.environ['bigip_admin_password'])
        self.bigip_hostname = os.environ['bigip_hostname']

    def get_bigip_virtual(self, project_id, listener_id):
        virtual_url = "https://%s/mgmt/tm/ltm/virtual/~Project_%s~Project_%s?expandSubcollections=true" % (
            self.bigip_hostname, project_id, listener_id)

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

if __name__ == "__main__":
    os.environ['bigip_admin_password'] = 'admin@f5'
    os.environ['bigip_hostname'] = '10.250.18.104'
    h = BigipHelper()
    print(h.get_bigip_virtual('472b437bc08c4f9f88466bcbb7250cda', 'sdfa'))