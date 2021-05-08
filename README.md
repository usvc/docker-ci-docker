# Docker image with Docker for CI use

[![pipeline status](https://gitlab.com/usvc/images/ci/docker/badges/master/pipeline.svg)](https://gitlab.com/usvc/images/ci/docker/commits/master)
[![dockerhub link](https://img.shields.io/badge/dockerhub-usvc%2Fci--docker-blue.svg)](https://hub.docker.com/r/usvc/ci-docker)

Docker is a container runtime that allows for Dockerfiles to be built into images for use in deployments. This repository contains instructions to build a Docker image with the following installed:

1. [Docker](https://www.docker.com/)
2. [Trivy](https://github.com/aquasecurity/trivy)
3. [Hadolint](https://github.com/hadolint/hadolint)
4. [Container Structure Test](https://github.com/GoogleContainerTools/container-structure-test)

**Table of Contents**
- [Docker image with Docker for CI use](#docker-image-with-docker-for-ci-use)
- [Usage](#usage)
  - [Local execution](#local-execution)
  - [As a base in other Docker images](#as-a-base-in-other-docker-images)
  - [GitLab CI](#gitlab-ci)
    - [Standard Usage](#standard-usage)
    - [With Docker-in-Docker (`dind`)](#with-docker-in-docker-dind)
- [Development Runbook](#development-runbook)
  - [Development](#development)
  - [Continuous Integration](#continuous-integration)
- [License](#license)

# Usage

## Local execution

For the packaged Docker client to work, you'll need to map your host's Docker daemon socket into the container. You can do this by running your Docker container using the `--volume` flag. An example of opening a shell into a container based on the `usvc/ci-docker:latest` image would be:

```sh
docker run -it \
  --env DOCKER_HOST= \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --entrypoint=/bin/sh \
  usvc/ci-docker:latest;
```

> The `DOCKER_HOST` is set to an empty value because this image is meant for Gitlab usage which requires `DOCKER_HOST` to be set to `tcp://docker:2375/` to work

## As a base in other Docker images

You can simply use the `FROM` directive for this:

```dockerfile
FROM usvc/ci-docker:latest
```

## GitLab CI

### Standard Usage

Use the image by specifying the `job.image` value as `"usvc/ci-docker:latest"`:

```yaml
job_name:
  stage: stage_name
  image: usvc/ci-docker:latest
  script:
    - ...
```

### With Docker-in-Docker (`dind`)

Use the image by specifying the `job.image` value as `"usvc/ci-docker:gitlab-latest"`. You'll also need to specify that you're using the `docker:dind` service.

```yaml
job_name:
  stage: stage_name
  image: usvc/ci-docker:latest
  services:
    - docker:dind
  script:
    - ...
```

# Development Runbook

## Development

2. Run `make lint` to lint the Dockerfile
1. Run `make build` to build the image
3. Run `make scan` to run security scans on the built image
4. Run `make test` to run contract tests against the built image
5. Run `make publish` to publish the image

## Continuous Integration

The following variables need to be defined in the CI pipieline:

1. `DOCKER_REGISTRY_URI`: the Docker registry to push to
1. `DOCKER_REGISTRY_USER`: user of the Docker registry to push to
1. `DOCKER_REGISTRY_PASSWORD`: password for the user of the Docker registry to push to


# License

Content herein is licensed under the [MIT license](./LICENSE).
