#!/bin/bash

FQDN="MyIPCam.local.net"

set -e

local_openssl_config="
[req]
distinguished_name = req_distinguished_name
x509_extensions = san_self_signed
prompt = no

[req_distinguished_name]
C = AT
ST = Vienna
L = Vienna
O = A1 Labs
OU = -
CN = $FQDN

[ san_self_signed ]
subjectAltName = @alt_names
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = CA:true
keyUsage = nonRepudiation, digitalSignature, keyEncipherment, dataEncipherment, keyCertSign, cRLSign
extendedKeyUsage = serverAuth, clientAuth, timeStamping

[alt_names]
DNS.1 = $FQDN
"
    
openssl req \
  -x509 \
  -sha256 \
  -newkey rsa:2048 \
  -nodes \
  -days 180 \
  -keyout "$FQDN.key.pem" \
  -config <(echo "$local_openssl_config") \
  -out "$FQDN.cert.pem"

openssl x509 -noout -text -in "$FQDN.cert.pem"
