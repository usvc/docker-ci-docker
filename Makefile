DOCKER_IMAGE_PATH=usvc/ci-docker

# override whatever you want in here
-include ./Makefile.properties

DATE_TIMESTAMP=$$(date +'%Y')$$(date +'%m')$$(date +'%d')

build:
	@docker build --tag ${DOCKER_IMAGE_PATH}:latest .
	@docker tag ${DOCKER_IMAGE_PATH}:latest ${DOCKER_IMAGE_PATH}:$(DATE_TIMESTAMP)

publish: build
	@docker push ${DOCKER_IMAGE_PATH}:latest
	@docker push ${DOCKER_IMAGE_PATH}:$(DATE_TIMESTAMP)
