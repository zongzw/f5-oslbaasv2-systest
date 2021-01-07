#!/bin/bash

set -e 

if [ -z "$1" ]; then 
    echo "ERROR: no loadbalancer name or id provided."
    exit 1 
fi

retries=10
delay=3

echo "loadbalancer: $1"

while [ $retries -gt 0 ]; do
    retries=$(($retries - 1))

    provisioning_status=`neutron lbaas-loadbalancer-show $1 --format value --column provisioning_status`
    echo "provisionging status: $provisioning_status"
    [ "$provisioning_status" = "ACTIVE" ] && exit 0 || continue
done

echo "timeout for waiting $1 to ACTIVE, quit."
exit 1
