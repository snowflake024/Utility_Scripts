#!/bin/bash

# Needs further work to be automated

NAME=$1
CN=$2

openssl req -new -sha256 -nodes \
  -out $NAME.csr \
  -keyout $NAME.key \
  -subj "/C=AT/ST=Vienna/L=Vienna/O=A1 Telekom Austria AG/OU=Technology/CN=$CN" \
  -config <(
cat <<-EOF
[req]
default_bits = 2048
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[dn]
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = 
EOF
)
