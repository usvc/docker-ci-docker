IMAGE_URL=usvc/ci-docker

# override whatever you want in here
-include ./Makefile.properties

DATE_TIMESTAMP=$$(date +'%Y')$$(date +'%m')$$(date +'%d')

build:
	$(MAKE) build_base
	$(MAKE) build_gitlab
build_base:
	docker build \
		--tag $(IMAGE_URL):latest \
		--target base \
		.
build_gitlab:
	docker build \
		--tag $(IMAGE_URL):gitlab-latest \
		--target gitlab \
		.

ci.export:
	$(MAKE) ci.export_base
	$(MAKE) ci.export_gitlab
ci.export_base:
	mkdir -p ./.export
	docker save --output ./.export/base.tar $(IMAGE_URL):latest
ci.export_gitlab:
	mkdir -p ./.export
	docker save --output ./.export/gitlab.tar $(IMAGE_URL):gitlab-latest

ci.import:
	-$(MAKE) ci.import_base
	-$(MAKE) ci.import_gitlab
ci.import_base:
	docker load --input ./.export/base.tar
ci.import_gitlab:
	docker load --input ./.export/gitlab.tar

test:
	$(MAKE) test_base
	$(MAKE) test_gitlab
test_base: build_base
	container-structure-test test \
	 	--verbosity debug \
	 	--image $(IMAGE_URL):latest \
		--config ./shared/tests/base.yml
test_gitlab: build_gitlab
	container-structure-test test \
	 	--verbosity debug \
	 	--image $(IMAGE_URL):gitlab-latest \
		--config ./shared/tests/gitlab.yml
test_from:
	@if [ "${TAG}" = "" ]; then \
		printf -- "\n\n\033[1m> you need to specify a TAG environment variable\033[0m\n\n"; \
		exit 1; \
	fi
	curl -Lo ./shared/tests/from.yml "https://gitlab.com/usvc/images/ci/base/raw/master/shared/tests/base.yml"
	container-structure-test test \
	 	--verbosity debug \
	 	--image $(IMAGE_URL):${TAG} \
		--config ./shared/tests/from.yml
	rm -rf ./shared/tests/from.yml

version_alpine:
	mkdir -p ./.version
	docker run --entrypoint=cat \
		$(IMAGE_URL):${TAG} /etc/alpine-release \
		> ./.version/alpine
version_docker:
	mkdir -p ./.version
	docker run \
		--entrypoint=docker \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		$(IMAGE_URL):${TAG} version --format '{{ .Client.Version }}' \
		> ./.version/docker

publish:
	$(MAKE) publish_base
	$(MAKE) publish_gitlab
publish_base:
	$(MAKE) version_alpine TAG=latest
	$(MAKE) version_docker TAG=latest
	mkdir -p ./.version
	docker push $(IMAGE_URL):latest
	# usvc/ci-docker:YYYYMMDD
	$(MAKE) utils.tag_and_push FROM=latest TO=$(DATE_TIMESTAMP)
	# usvc/ci-docker:alpine-<alpine_version>
	$(MAKE) utils.tag_and_push FROM=latest TO=alpine-$$(cat ./.version/alpine)
	# usvc/ci-docker:<docker_client_version>
	$(MAKE) utils.tag_and_push FROM=latest TO=$$(cat ./.version/docker)
publish_gitlab:
	$(MAKE) version_alpine TAG=gitlab-latest
	$(MAKE) version_docker TAG=gitlab-latest
	mkdir -p ./.version
	docker push $(IMAGE_URL):gitlab-latest
	# usvc/ci-docker:gitlab-YYYYMMDD
	$(MAKE) utils.tag_and_push FROM=gitlab-latest TO=gitlab-$(DATE_TIMESTAMP)
	# usvc/ci-docker:gitlab-alpine-<alpine_version>
	$(MAKE) utils.tag_and_push FROM=latest TO=gitlab-alpine-$$(cat ./.version/alpine)
	# usvc/ci-docker:gitlab-<docker_client_version>
	$(MAKE) utils.tag_and_push FROM=gitlab-latest TO=gitlab-$$(cat ./.version/docker)

utils.tag_and_push:
	docker tag $(IMAGE_URL):${FROM} $(IMAGE_URL):${TO}
	docker push $(IMAGE_URL):${TO}
