# `ci-docker`

[![pipeline status](https://gitlab.com/usvc/ci-docker/badges/master/pipeline.svg)](https://gitlab.com/usvc/ci-docker/commits/master)


A CI image for use in `usvc` projects which require Docker to build.

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
