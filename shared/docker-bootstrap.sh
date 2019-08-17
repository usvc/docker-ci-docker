#!/bin/sh
apk add --no-cache docker py-pip python-dev libffi-dev libc-dev openssl-dev;
pip install --no-cache-dir docker-compose;
curl -Lo /bin/container-structure-test "https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64";
chmod +x /bin/container-structure-test;
