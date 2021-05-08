REGISTRY := docker.io
NAMESPACE := usvc
REPO := ci-docker
COMMIT_SHA := $(shell git rev-parse HEAD)

# use this to override the above
-include ./Makefile.properties

VERSION := $(shell date +'%Y%m%d%H%M%S')

# builds this image
build:
	docker build --tag $(NAMESPACE)/$(REPO):latest .

# lints this image for best-practices
lint:
	hadolint ./Dockerfile

# tests this iamge for structure integrity
test: build
	container-structure-test test --config ./.Dockerfile.yaml --image $(NAMESPACE)/$(REPO):latest

# scans this image for known vulnerabilities
scan: build
	trivy image $(NAMESPACE)/$(REPO):latest

# publishes this image using the date/time stamp
publish: build
	docker tag $(NAMESPACE)/$(REPO):latest $(REGISTRY)/$(NAMESPACE)/$(REPO):$(VERSION)
	docker push $(REGISTRY)/$(NAMESPACE)/$(REPO):$(VERSION)

# publishes this image using the commit sha without building
publish-ci:
	docker tag $(NAMESPACE)/$(REPO):latest $(REGISTRY)/$(NAMESPACE)/$(REPO):$(COMMIT_SHA)
	docker push $(REGISTRY)/$(NAMESPACE)/$(REPO):$(COMMIT_SHA)

# exports this image into a tarball (use in ci cache)
export: build
	mkdir -p ./images
	docker save $(NAMESPACE)/$(REPO):latest -o ./images/$(NAMESPACE)-$(REPO).tar.gz

# import this image from a tarball (use in ci cache)
import:
	mkdir -p ./images
	-docker load -i ./images/$(NAMESPACE)-$(REPO).tar.gz
