FROM alpine:latest AS base
RUN wget -O /usr/bin/alpine-bootstrap.sh https://gitlab.com/usvc/images/ci/base/raw/master/shared/alpine-bootstrap.sh \
  && chmod +x /usr/bin/alpine-bootstrap.sh \
  && /usr/bin/alpine-bootstrap.sh
RUN apk add --no-cache docker py-pip python-dev libffi-dev libc-dev openssl-dev
RUN pip install --no-cache-dir docker-compose
LABEL \
  description="a ci image for use with builds that require docker" \
  author="zephinzer" \
  maintainer="zephinzer" \
  canonical_url="https://gitlab.com/usvc/ci/docker"
RUN curl -Lo /bin/container-structure-test "https://storage.googleapis.com/container-structure-test/latest/container-structure-test-linux-amd64" \
  && chmod +x /bin/container-structure-test

FROM base AS gitlab
ENV DOCKER_HOST=tcp://docker:2375/ \
  DOCKER_DRIVER=overlay2
