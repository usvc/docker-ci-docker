#!/bin/sh
set -x;

#
# base docker tools
#
apk add --no-cache docker gcc libffi-dev musl-dev openssl-dev py-pip python-dev;
pip install --no-cache-dir docker-compose;
apk del --no-cache gcc py-pip libffi-dev musl-dev openssl-dev

#
# container-structure-test
#
curl -Lo /bin/container-structure-test "https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64";
chmod +x /bin/container-structure-test;
