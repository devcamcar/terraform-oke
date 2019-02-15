#!/usr/bin/env bash
set -e

# Generate OCI API Key.
openssl genrsa -out ./keys/oci-api-private-key.pem 2048
chmod go-r ./keys/oci-api-private-key.pem
openssl rsa -pubout -in ./keys/oci-api-private-key.pem -out ./keys/oci-api-public-key.pem
openssl rsa -pubout -outform DER -in ./keys/oci-api-private-key.pem | openssl md5 -c > ./keys/oci-api-fingerprint
