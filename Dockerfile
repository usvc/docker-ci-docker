FROM usvc/ci-base:latest AS base
RUN apk update --no-cache && apk upgrade --no-cache
RUN apk add --no-cache docker
RUN apk add --no-cache py-pip
RUN apk add --no-cache python-dev
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache libc-dev
RUN apk add --no-cache openssl-dev
RUN pip install --no-cache-dir docker-compose
LABEL \
  description="a ci image for use with builds that require docker" \
  author="zephinzer" \
  maintainer="zephinzer" \
  canonical_url="https://gitlab.com/usvc/images/ci-docker"

FROM base AS gitlab
ENV DOCKER_HOST=tcp://docker:2375/ \
  DOCKER_DRIVER=overlay2
