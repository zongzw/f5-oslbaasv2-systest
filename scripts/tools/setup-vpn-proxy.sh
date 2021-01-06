#!/bin/bash

# This is an interactive script. 
#   Checking for missing dependency packages for command line client ...
#   executing command : /usr/local/pulse/pulsesvc
#   VPN Password: 
username=functionid
hostname=183.84.2.165

if [ ! -f /usr/local/pulse/PulseClient_x86_64.sh ]; then
    echo "PulseSecure is not available, install it."
    exit 1
fi

ps -ef | grep -v grep | grep pulsesvc > /dev/null
if [ $? -ne 0 ]; then
    echo "Starting VPN connection ..."
    (/usr/local/pulse/PulseClient_x86_64.sh \
        -h $hostname -u $username -r Users &)
fi

wait=60
while [ $wait -gt 0 ]; do
    wait=$(($wait - 1))
    sleep 1
    ifconfig tun0 > /dev/null
    if [ $? -ne 0 ]; then
        echo "waiting for tun0 is ready: $wait"
        continue
    else
        ifconfig tun0 | grep "inet 10.250.64."
        exit 0
    fi
done

echo "Timeout for waiting, no tun0 found."
exit 1