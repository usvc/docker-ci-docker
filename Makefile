DOCKER_IMAGE_PATH=usvc/ci-docker

# override whatever you want in here
-include ./Makefile.properties

DATE_TIMESTAMP=$$(date +'%Y')$$(date +'%m')$$(date +'%d')

build:
	@docker build \
		--tag ${DOCKER_IMAGE_PATH}:latest \
		--target base \
		.
	@docker tag ${DOCKER_IMAGE_PATH}:latest ${DOCKER_IMAGE_PATH}:$(DATE_TIMESTAMP)
	@docker tag ${DOCKER_IMAGE_PATH}:latest ${DOCKER_IMAGE_PATH}:$$(docker run --entrypoint=docker ${DOCKER_IMAGE_PATH}:latest version --format '{{.Client.Version}}')

build_gitlab:
	@docker build \
		--tag ${DOCKER_IMAGE_PATH}:gitlab-latest \
		--target gitlab \
		.
	@docker tag ${DOCKER_IMAGE_PATH}:gitlab-latest ${DOCKER_IMAGE_PATH}:gitlab-$(DATE_TIMESTAMP)
	@docker tag ${DOCKER_IMAGE_PATH}:gitlab-latest ${DOCKER_IMAGE_PATH}:gitlab-$$(docker run --entrypoint=docker ${DOCKER_IMAGE_PATH}:latest version --format '{{.Client.Version}}')

publish: build build_gitlab
	@docker push ${DOCKER_IMAGE_PATH}:latest
	@docker push ${DOCKER_IMAGE_PATH}:$(DATE_TIMESTAMP)
	@docker push ${DOCKER_IMAGE_PATH}:$$(docker run --entrypoint=docker ${DOCKER_IMAGE_PATH}:latest version --format '{{.Client.Version}}')
	@docker push ${DOCKER_IMAGE_PATH}:gitlab-latest
	@docker push ${DOCKER_IMAGE_PATH}:gitlab-$(DATE_TIMESTAMP)
	@docker push ${DOCKER_IMAGE_PATH}:gitlab-$$(docker run --entrypoint=docker ${DOCKER_IMAGE_PATH}:latest version --format '{{.Client.Version}}')
