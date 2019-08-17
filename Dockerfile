FROM alpine:latest AS base
RUN wget -O /usr/bin/alpine-bootstrap.sh https://gitlab.com/usvc/images/ci/base/raw/master/shared/alpine-bootstrap.sh \
  && chmod +x /usr/bin/alpine-bootstrap.sh \
  && /usr/bin/alpine-bootstrap.sh \
  && rm -rf /usr/bin/alpine-bootstrap.sh
COPY ./shared/docker-bootstrap.sh /usr/bin/docker-bootstrap.sh
RUN chmod +x /usr/bin/docker-bootstrap.sh \
  && /usr/bin/docker-bootstrap.sh
WORKDIR /
LABEL \
  description="A ci image for use with builds that require docker" \
  canonical_url="https://gitlab.com/usvc/images/ci/docker" \
  license="MIT" \
  maintainer="zephinzer" \
  authors="zephinzer"

FROM base AS gitlab
# for more info, see:
#   https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
ENV DOCKER_HOST=tcp://docker:2375/ \
  DOCKER_DRIVER=overlay2
