#!/bin/bash

set -e 

if [ -z "$1" ]; then 
    echo "ERROR: no loadbalancer name or id provided."
    exit 1 
fi

retries=30
delay=6

echo "loadbalancer: $1"

while [ $retries -gt 0 ]; do
    retries=$(($retries - 1))
    sleep $delay
    
    provisioning_status=`neutron lbaas-loadbalancer-show $1 --format value --column provisioning_status`
    echo "provisionging status: $provisioning_status"
    if [ "$provisioning_status" = "ACTIVE" ]; then
        exit 0
    elif [ "$provisioning_status" = "ERROR" ]; then 
        exit 1
    fi
    continue
done

echo "timeout for waiting $1 to ACTIVE, quit."
exit 1
