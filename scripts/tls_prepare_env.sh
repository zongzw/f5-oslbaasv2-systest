#!/bin/bash -e

rm -rf /tmp/test_tls_* && mkdir ${SSL_DIR}

echo "basicConstraints=CA:TRUE" > ${SSL_DIR}/v3.ext

echo "Create CA certificate"
openssl genrsa -out ${CA_CERT}.key 1024
openssl req -new -key ${CA_CERT}.key -out ${CA_CERT}.csr -subj "/C=CN/ST=BJ/L=BJ/O=ABC/OU=IT/CN=testca${TEST_TIME}.com/emailAddress=ask@testca.com"
openssl x509 -req -in ${CA_CERT}.csr -signkey ${CA_CERT}.key -out ${CA_CERT}.crt -extfile ${SSL_DIR}/v3.ext

openssl x509 -in ${CA_CERT}.crt -noout -text

echo "Create server certificate"
openssl genrsa -des3 -passout pass:1234 -out ${SERVER_CERT}.key 1024
openssl req -new -key ${SERVER_CERT}.key -passin pass:1234 -out ${SERVER_CERT}.csr -subj "/C=CN/ST=BJ/L=BJ/O=Example/OU=IT/CN=test${TEST_TIME}.com/emailAddress=ask@test.com"
openssl x509 -req -in ${SERVER_CERT}.csr -out ${SERVER_CERT}.crt -CA ${CA_CERT}.crt -CAkey ${CA_CERT}.key -CAcreateserial

openssl verify -CAfile ${CA_CERT}.crt -verbose ${SERVER_CERT}.crt
openssl x509 -in ${SERVER_CERT}.crt -noout -text

echo "Create client certificate"
openssl genrsa -des3 -passout pass:1234 -out ${CLIENT_CERT}.key 1024
openssl req -new -key ${CLIENT_CERT}.key -passin pass:1234 -out ${CLIENT_CERT}.csr -subj "/C=CN/ST=BJ/L=BJ/O=Example/OU=IT/CN=client.com/emailAddress=ask@client.com"
openssl x509 -req -in ${CLIENT_CERT}.csr -out ${CLIENT_CERT}.crt -CA ${CA_CERT}.crt -CAkey ${CA_CERT}.key -CAcreateserial

openssl verify -CAfile ${CA_CERT}.crt -verbose ${CLIENT_CERT}.crt
openssl x509 -in ${CLIENT_CERT}.crt -noout -text

touch ${SSL_DIR}/crl_index.txt
echo 00 > ${SSL_DIR}/crl_number

cat <<EOF > ${SSL_DIR}/crl_openssl.conf
# OpenSSL configuration for CRL generation
#
####################################################################
[ ca ]
default_ca      = CA_default            # The default ca section

####################################################################
[ CA_default ]
database = ${SSL_DIR}/crl_index.txt
crlnumber = ${SSL_DIR}/crl_number


default_days    = 365                   # how long to certify for
default_crl_days= 30                    # how long before next CRL
default_md      = default               # use public key default MD
preserve        = no                    # keep passed DN ordering

####################################################################
[ crl_ext ]
# CRL extensions.
# Only issuerAltName and authorityKeyIdentifier make any sense in a CRL.
# issuerAltName=issuer:copy
authorityKeyIdentifier=keyid:always,issuer:always
EOF

openssl ca -config ${SSL_DIR}/crl_openssl.conf -gencrl -keyfile ${CA_CERT}.key -cert ${CA_CERT}.crt -out ${CLIENT_CRL}.pem
