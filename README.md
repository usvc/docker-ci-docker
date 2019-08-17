# Base Image containing Docker for CI use 

[![pipeline status](https://gitlab.com/usvc/images/ci/docker/badges/master/pipeline.svg)](https://gitlab.com/usvc/images/ci/docker/commits/master)
[![dockerhub link](https://img.shields.io/badge/dockerhub-usvc%2Fci--docker-blue.svg)](https://hub.docker.com/r/usvc/ci-docker)

A lightweight CI image for use in `usvc` projects which require Docker operations.

Contains tools from [`usvc/ci-base` (click to see the repository)](https://gitlab.com/usvc/images/ci/base) and also:
  - the Docker daemon
  - the Docker Compose CLI tool

# Usage

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
  image: usvc/ci-docker:gitlab-latest
  services:
    - docker:dind
  script:
    - ...
```

# Development Runbook

## CI Configuration

Set the following variables in the environment variable configuration of your GitLab CI:

| Key | Value |
| ---: | :--- |
| DOCKER_REGISTRY_URL | URL to your Docker registry |
| DOCKER_REGISTRY_USER | Username for your registry user |
| DOCKER_REGISTRY_PASSWORD | Password for your registry user |

# License

Content herein is licensed under the [MIT license](./LICENSE).
