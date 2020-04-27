SHELL = /bin/bash

.PHONY = module clean

TOPDIR := $(shell git rev-parse --show-toplevel 2> /dev/null || pwd | awk -F 'alation-analytics' '{print $$1}')
VER := $(shell cat changelog.yaml | shyaml get-value ver.current-version || cat changelog.yaml | grep current-version | cut -d':' -f2 | awk '$$1=$$1')
CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS), Darwin)
	TOPDIR := $(TOPDIR)/src/alation-analytics
else
	TOPDIR := $(TOPDIR)/alation-analytics
endif
DOCKER_REPO := registry.io
BASE_DOCKER_REPO := alation-analytics-docker-virtual.alationdevops.com
CONTAINER := grafana
IMG_TAG := $(DOCKER_REPO)/$(CONTAINER)
NETWORK_NAME := alation-analytics
BASE_IMG_TAG := $(BASE_DOCKER_REPO)/$(CONTAINER):$(VER)
BASE_REPO := grafana/grafana
BASE_VER := 6.7.3
APP_REPO := https://github.com/grafana/grafana.git
APP_TAG := v6.7.3

module: network build run

network:
	@echo Creating Docker Networking
	@docker network inspect $(NETWORK_NAME) 2> /dev/null || docker network create -d bridge $(NETWORK_NAME)

#build-base:
#	@echo Building Base Image
#	@docker pull $(BASE_REPO):$(BASE_VER)
#	@docker tag $(BASE_REPO):$(BASE_VER) $(BASE_IMG_TAG)

build-binary: network pull-grafana run-builder

run-builder:
	@echo Building build container
	@docker build --rm --tag grafana-builder -f Dockerfile-Builder .
	@docker run -m 8g --name grafana-builder grafana-builder
	@docker cp grafana-builder:/go/src/grafana/bin/linux-amd64 ./build/linux-amd64
	@docker cp grafana-builder:/go/src/grafana/public ./build/public
	@docker rm -f grafana-builder
	@docker rmi -f grafana-builder
	@rm -rf src

pull-grafana:
	@echo Building Grafana
	@rm -rf src
	@git clone $(APP_REPO) src
	@cd src && git checkout tags/$(APP_TAG)

build-image:
	@echo Building $(CONTAINER)
	@docker build --rm -f Dockerfile-Grafana --tag $(IMG_TAG) .

run:
	@echo Running $(CONTAINER)
	@docker run -d -it --name $(CONTAINER) --restart on-failure -p 3000:3000 --net $(NETWORK_NAME) $(IMG_TAG)


#push-base: build-base
#	@echo Pushing Base Image
#	@docker push $(BASE_IMG_TAG)
#
#build:
#	@echo Building $(CONTAINER)
#	@docker build --rm --tag $(IMG_TAG) .
#
#run:
#	@echo Running $(CONTAINER)
#	@docker run -d -it --name $(CONTAINER) --restart on-failure -p 3000:3000 --net $(NETWORK_NAME) $(IMG_TAG)
#
#clean:
#	@echo Removing $(IMG_TAG)  Image
#	@docker ps -a | grep $(CONTAINER) | cut -d ' ' -f 1 | xargs docker rm -f
#	@docker images -a | grep $(DOCKER_REPO)/$(CONTAINER) | awk '{print $$3}' | xargs docker rmi -f
