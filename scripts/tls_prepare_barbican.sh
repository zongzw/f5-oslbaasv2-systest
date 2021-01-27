#!/bin/bash -e

echo "create server container"
SERVER_CERT_REF=$(openstack secret store --secret-type=certificate --payload-content-type='text/plain' --name="${SERVER_CERT}.crt" --payload="$(cat ${SERVER_CERT}.crt)" | grep "Secret href" | awk '{ print $5 }')
SERVER_CERT_KEY_REF=$(openstack secret store --secret-type=private --payload-content-type='text/plain' --name="${SERVER_CERT}.key" --payload="$(cat ${SERVER_CERT}.key)" | grep "Secret href" | awk '{ print $5 }')
SERVER_CERT_KEYPASS_REF=$(openstack secret store --secret-type=passphrase --payload-content-type='text/plain' --name="${SERVER_CERT}.pass" --payload="1234" | grep "Secret href" | awk '{ print $5 }')
sleep 3
SERVER_CERT_CREF=$(openstack secret container create --name="${SERVER_CERT}.container" --type='certificate' \
  --secret="certificate=${SERVER_CERT_REF}" \
  --secret="private_key=${SERVER_CERT_KEY_REF}" \
  --secret="private_key_passphrase=${SERVER_CERT_KEYPASS_REF}" | grep "Container href" | awk '{ print $5 }')

echo "create ca container"
CA_CERT_REF=$(openstack secret store --secret-type=certificate --payload-content-type='text/plain' --name="${CA_CERT}.crt" --payload="$(cat ${CA_CERT}.crt)" | grep "Secret href" | awk '{ print $5 }')
CA_CERT_CREF=$(openstack secret container create --name="${CA_CERT}.container" --type='certificate' \
  --secret="certificate=${CA_CERT_REF}" | grep "Container href" | awk '{ print $5 }')

echo $CA_CERT_CREF > /tmp/test_CA_CERT_CREF
echo $SERVER_CERT_CREF > /tmp/test_SERVER_CERT_CREF
