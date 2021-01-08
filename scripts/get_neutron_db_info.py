import configparser
import re
import sys

if len(sys.argv) != 2:
    print("no key name provided.")
    sys.exit(1)

key = sys.argv[1]

conf = configparser.ConfigParser()

with open('/etc/neutron/neutron.conf') as fr:
    conf.readfp(fr)

opt  = conf.get('database', 'connection')
# print(opt)

matched = re.match(r".*://(\w+):(\w+)@([0-9\.]+)/(\w+)", opt)
if matched:
    info = {
        'username': matched.group(1),
        'password': matched.group(2),
        'hostname': matched.group(3),
        'database': matched.group(4)
    }
    # print(info)
    print(info[key])
else:
    print("failed to match %s" % opt)