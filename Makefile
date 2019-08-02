IMAGE_URL=usvc/ci-docker

# override whatever you want in here
-include ./Makefile.properties

DATE_TIMESTAMP=$$(date +'%Y')$$(date +'%m')$$(date +'%d')

build:
	@docker build \
		--tag ${IMAGE_URL}:latest \
		--target base \
		.

test: build
	@container-structure-test test \
	 	--verbosity debug \
	 	--image $(IMAGE_URL):latest \
		--config test.yaml

build_gitlab:
	@docker build \
		--tag ${IMAGE_URL}:gitlab-latest \
		--target gitlab \
		.

publish: build build_gitlab
	@docker push ${IMAGE_URL}:latest
	@docker tag ${IMAGE_URL}:latest ${IMAGE_URL}:$(DATE_TIMESTAMP)
	@docker push ${IMAGE_URL}:$(DATE_TIMESTAMP)
	@docker tag ${IMAGE_URL}:latest ${IMAGE_URL}:$$(docker run --entrypoint=docker -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE_URL}:latest version --format '{{ .Client.Version }}')
	@docker push ${IMAGE_URL}:$$(docker run --entrypoint=docker -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE_URL}:latest version --format '{{ .Client.Version }}')
	@docker push ${IMAGE_URL}:gitlab-latest
	@docker tag ${IMAGE_URL}:gitlab-latest ${IMAGE_URL}:gitlab-$(DATE_TIMESTAMP)
	@docker push ${IMAGE_URL}:gitlab-$(DATE_TIMESTAMP)
	@docker tag ${IMAGE_URL}:gitlab-latest ${IMAGE_URL}:gitlab-$$(docker run --entrypoint=docker -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE_URL}:latest version --format '{{ .Client.Version }}')
	@docker push ${IMAGE_URL}:gitlab-$$(docker run --entrypoint=docker -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE_URL}:latest version --format '{{ .Client.Version }}')
