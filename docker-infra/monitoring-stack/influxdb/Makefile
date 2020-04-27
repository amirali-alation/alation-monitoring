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
CONTAINER := influxdb
IMG_TAG := $(DOCKER_REPO)/$(CONTAINER)
NETWORK_NAME := alation-analytics
BASE_IMG_TAG := $(BASE_DOCKER_REPO)/$(CONTAINER):$(VER)
CONTAINER_BASE_DIR := /alation_analytics/
LOCAL_BASE := $(shell pwd)/ETL_code
ETL_CODE := $(TOPDIR)/etl-code/

module: network build run

network:
	@echo Creating Docker Networking
	@docker network inspect $(NETWORK_NAME) 2> /dev/null || docker network create -d bridge $(NETWORK_NAME)

build-base:
	@echo Building Base Image
	@docker build -f $(shell pwd)/Base-Dockerfile --rm --tag $(BASE_IMG_TAG) .


push-base: build-base
	@echo Pushing Base Image
	@docker push $(BASE_IMG_TAG)

build:
	@echo Building $(CONTAINER)
	@docker build --rm --tag $(IMG_TAG) .

run:
	@echo Running $(CONTAINER)
	@docker run -d -it --name $(CONTAINER) --restart on-failure  --net $(NETWORK_NAME) $(IMG_TAG)

clean:
	@echo Removing $(IMG_TAG)  Image
	@docker ps -a | grep $(CONTAINER) | cut -d ' ' -f 1 | xargs docker rm -f
	@docker images -a | grep $(DOCKER_REPO)/$(CONTAINER) | awk '{print $$3}' | xargs docker rmi -f
