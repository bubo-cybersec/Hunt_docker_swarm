#!/bin/bash
# Generate certificates for your OpenSearch cluster

OPENDISTRO_DN="/C=FR/ST=PACA/L=GARDANNE/O=EXAMPLE"

sudo mkdir -p certs/{ca,os-dashboards}

# Root CA
sudo openssl genrsa -out certs/ca/ca.key 2048
sudo openssl req -new -x509 -sha256 -days 400 -subj "$OPENDISTRO_DN/CN=CA" -key certs/ca/ca.key -out certs/ca/ca.pem

# Admin
sudo openssl genrsa -out certs/ca/admin-temp.key 2048
sudo openssl pkcs8 -inform PEM -outform PEM -in certs/ca/admin-temp.key -topk8 -nocrypt -v1 PBE-SHA1-3DES -out certs/ca/admin.key
sudo openssl req -new -subj "$OPENDISTRO_DN/CN=ADMIN" -key certs/ca/admin.key -out certs/ca/admin.csr
sudo openssl x509 -req -in certs/ca/admin.csr -CA certs/ca/ca.pem -CAkey certs/ca/ca.key -CAcreateserial -sha256 -out certs/ca/admin.pem

# OpenSearch Dashboards
sudo openssl genrsa -out certs/os-dashboards/os-dashboards-temp.key 2048
sudo openssl pkcs8 -inform PEM -outform PEM -in certs/os-dashboards/os-dashboards-temp.key -topk8 -nocrypt -v1 PBE-SHA1-3DES -out certs/os-dashboards/os-dashboards.key
sudo openssl req -new -day 400 -subj "$OPENDISTRO_DN/CN=os-dashboards" -key certs/os-dashboards/os-dashboards.key -out certs/os-dashboards/os-dashboards.csr
sudo openssl x509 -req -in certs/os-dashboards/os-dashboards.csr -CA certs/ca/ca.pem -CAkey certs/ca/ca.key -CAcreateserial -sha256 -out certs/os-dashboards/os-dashboards.pem
sudo rm certs/os-dashboards/os-dashboards-temp.key certs/os-dashboards/os-dashboards.csr

# Nodes
for NODE_NAME in "master1" "data1" "data2" "data3" "data4" "coordinate"
do
    sudo mkdir "certs/${NODE_NAME}"
    sudo openssl genrsa -out "certs/$NODE_NAME/$NODE_NAME-temp.key" 2048
    sudo openssl pkcs8 -inform PEM -outform PEM -in "certs/$NODE_NAME/$NODE_NAME-temp.key" -topk8 -nocrypt -v1 PBE-SHA1-3DES -out "certs/$NODE_NAME/$NODE_NAME.key"
    sudo openssl req -new -day 400 -subj "$OPENDISTRO_DN/CN=$NODE_NAME" -key "certs/$NODE_NAME/$NODE_NAME.key" -out "certs/$NODE_NAME/$NODE_NAME.csr"
    sudo openssl x509 -req -extfile <(printf "subjectAltName=DNS:localhost,IP:127.0.0.1,DNS:$NODE_NAME") -in "certs/$NODE_NAME/$NODE_NAME.csr" -CA certs/ca/ca.pem -CAkey certs/ca/ca.key -CAcreateserial -sha256 -out "certs/$NODE_NAME/$NODE_NAME.pem"
    sudo rm "certs/$NODE_NAME/$NODE_NAME-temp.key" "certs/$NODE_NAME/$NODE_NAME.csr"
done
