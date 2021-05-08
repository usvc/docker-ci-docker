FROM docker:19.03.15 AS base
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN apk add --no-cache curl jq make
WORKDIR /tmp

# ref https://github.com/docker/compose/releases
ARG DOCKER_COMPOSE_VERSION=1.29.1
RUN curl -Lo /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64" \
  && chmod 750 /usr/local/bin/docker-compose
RUN apk add --no-cache zlib gcompat libc6-compat

# ref https://github.com/GoogleContainerTools/container-structure-test/releases
ARG CONTAINER_STRUCTURE_TEST_VERSION=v1.10.0
RUN curl -Lo /usr/local/bin/container-structure-test "https://storage.googleapis.com/container-structure-test/${CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test-linux-amd64" \
  && chmod 750 /usr/local/bin/container-structure-test

# ref https://github.com/hadolint/hadolint/releases/
ARG HADOLINT_VERSION=v2.4.0
RUN curl -Lo /usr/local/bin/hadolint "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
  && chmod 750 /usr/local/bin/hadolint

# ref https://github.com/aquasecurity/trivy/releases
ARG TRIVY_VERSION=0.17.2
RUN curl -fLo ./trivy.tar.gz "https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz" \
  && tar xfz ./trivy.tar.gz \
  && rm -rf ./trivy.tar.gz \
  && chmod 750 ./trivy \
  && mv ./trivy /usr/local/bin/trivy

VOLUME [ "/var/run/docker.sock" ]
ENTRYPOINT ["/bin/sh", "-c"]
# ref https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
ENV DOCKER_HOST=tcp://docker:2375/
ENV DOCKER_DRIVER=overlay2
