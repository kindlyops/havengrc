#!/bin/bash

# generate self-signed certs for use in dev and testing environments
openssl genrsa -out privkey.pem 2048

openssl req -new -key privkey.pem -out server.csr -subj "/CN=dev.havengrc.com"

openssl x509 -req -signkey privkey.pem -in server.csr -out server.pem
