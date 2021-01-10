#!/bin/bash -e

wait_until_loadbalancer () {
  local LB=$1
  local EXPECTED_STATUS=$2
  local STATUS="unknown"
  local timeout=60

  while [[ $STATUS != $EXPECTED_STATUS ]] && [[ $timeout -gt 0 ]] ; do
    STATUS=$(neutron lbaas-loadbalancer-show $LB | grep provisioning_status | awk '{ print $4 }')
    if [[ $STATUS == "ERROR" ]] ; then
      echo "$LB is in $STATUS state. Exit"
      exit 1
    fi
    if [[ $STATUS != $EXPECTED_STATUS ]] ; then
      echo "$LB is in $STATUS state. Wait for a while"
      sleep 1
      ((timeout=timeout-1))
    else
      break
    fi
  done
}

get_listener_id() {
  local LISTENER_NAME=$1
  neutron lbaas-listener-show ${LISTENER_NAME} | awk '$2 == "id" { print $4 }'
}

get_vs() {
  URI="https://admin:admin@${BIGIP_VM_IP}/mgmt/tm/ltm/virtual/~Project_${TENANT_ID}~Project_${LISTENER_ID}"
  curl -sk -X GET ${URI}
}

get_vs_profiles() {
  URI="https://admin:admin@${BIGIP_VM_IP}/mgmt/tm/ltm/virtual/~Project_${TENANT_ID}~Project_${LISTENER_ID}/profiles"
  curl -sk -X GET ${URI}
}

function get_clientssl_profile() {
  URI="https://admin:admin@${BIGIP_VM_IP}/mgmt/tm/ltm/virtual/~Project_${TENANT_ID}~Project_${LISTENER_ID}/profiles/~Common~$1"
  curl -sk -X GET ${URI}
}

source /stack/keystonerc_admin

DT=`date +%Y%m%d_%H%M%S`
SUFFIX=${CI_JOB_ID:-1}-${DT}
BIGIP_VM_IP=${BIGIP_VM_IP:-unknown}
TENANT_ID=$(openstack project show ${OS_PROJECT_NAME} | awk '$2 == "id" { print $4 }')

echo "Verify and get barbican secret container href"
CONTAINER_HREF=`barbican secret container list --format value --column "Container href" | tail -1`
CONTAINER_ID=`echo ${CONTAINER_HREF} | grep -oE "[0-99a-z\-]{36}"`

rm -f /stack/clientssl_function_test.done

echo "Create CLIENTSSL Loadbalancer"

LB_NAME=lb-clientssl-${SUFFIX}

neutron lbaas-loadbalancer-create $(neutron subnet-list | awk '/ public-subnet / {print $2}') --name ${LB_NAME}
wait_until_loadbalancer ${LB_NAME} ACTIVE

echo "Create TERMINATED_HTTPS listener"

LISTENER_NAME=listener-clientssl-${SUFFIX}

neutron lbaas-listener-create --default-tls-container-ref ${CONTAINER_HREF} --sni-container-refs ${CONTAINER_HREF} \
    --loadbalancer ${LB_NAME} --protocol TERMINATED_HTTPS --protocol-port 443 --name ${LISTENER_NAME}
wait_until_loadbalancer ${LB_NAME} ACTIVE

LISTENER_ID=$(get_listener_id ${LISTENER_NAME})

# check VS existence
EXPECTED_VS_NAME=Project_${LISTENER_ID}
VS_NAME=$(get_vs | jq -r .name)
echo "--------------------------------------------------"
echo "Expected VS name is $EXPECTED_VS_NAME."
echo "Actual VS name is $VS_NAME"
echo "--------------------------------------------------"

if [[ $EXPECTED_VS_NAME != $VS_NAME ]]; then
  echo "VS did not be created successfully"
  echo "Expected VS name is $EXPECTED_VS_NAME, but actual VS name is $VS_NAME"
  exit 1
fi

# check VS and clientssl profile binding existence 
EXPECTED_PROFILE_NAME=Project_${CONTAINER_ID}
get_vs_profiles
echo "Checking VS contains client ssl profile: ${CONTAINER_ID} ... "
get_vs_profiles | python -m json.tool | grep ${EXPECTED_PROFILE_NAME}

echo "CLIENT SSL profile detail:"
get_clientssl_profile ${EXPECTED_PROFILE_NAME} | python -m json.tool

echo "Testing updating TLS function ..."

OS_HOST=${RDO_VM_IP:localhost} \
OS_PROJECT_ID=${TENANT_ID} \
OS_USERNAME=${OS_USERNAME} OS_PASSWORD=${OS_PASSWORD} \
LISTENER_ID=${LISTENER_ID} \
BIGIP_CREDENTIAL=admin:admin \
BIGIP_HOST=${BIGIP_VM_IP} \
python /stack/clientssl_function_test_update-tls.py

# check lb and listener deletion.
echo "Check client ssl profile deletion"
neutron lbaas-listener-delete ${LISTENER_ID}
wait_until_loadbalancer ${LB_NAME} ACTIVE

neutron lbaas-loadbalancer-delete ${LB_NAME}

echo "CLIENT SSL Test DONE"
touch /stack/clientssl_function_test.done
