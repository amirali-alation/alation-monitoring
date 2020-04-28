SHELL = /bin/bash

.PHONY = module clean

TOPDIR := $(shell git rev-parse --show-toplevel 2> /dev/null || pwd | awk -F 'alation-analytics' '{print $$1}')
VER := $(shell cat changelog-grafana.yaml | shyaml get-value ver.current-version || cat changelog-grafana.yaml | grep current-version | cut -d':' -f2 | awk '$$1=$$1')
BUILDER_VER := $(shell cat changelog-builder.yaml | shyaml get-value ver.current-version || cat changelog-builder.yaml | grep current-version | cut -d':' -f2 | awk '$$1=$$1')
CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS), Darwin)
	TOPDIR := $(TOPDIR)/src/alation-analytics
else
	TOPDIR := $(TOPDIR)/alation-analytics
endif
DOCKER_REPO := registry.io
BASE_DOCKER_REPO := alation-analytics-docker-virtual.alationdevops.com
CONTAINER := grafana
BIULDER_CONTAINER := grafana-builder
IMG_TAG := $(DOCKER_REPO)/$(CONTAINER)
NETWORK_NAME := alation-analytics
BASE_IMG_TAG := $(BASE_DOCKER_REPO)/$(CONTAINER):$(VER)
BASE_BUILDER_IMG_TAG := $(BASE_DOCKER_REPO)/$(BIULDER_CONTAINER):$(BUILDER_VER)
BASE_REPO := grafana/grafana
APP_REPO := https://github.com/grafana/grafana.git
APP_TAG := v6.7.3

##@ Infra

network: ## Create a network for Alation Analytics which will be used for all containers in AA
	@echo Creating Docker Networking
	@docker network inspect $(NETWORK_NAME) 2> /dev/null || docker network create -d bridge $(NETWORK_NAME)

##@ Build

build-base-grafana: ## Build the base image for Grafana container
	@echo Building Base Image
	@docker build -f Base-Dockerfile-Grafana --rm --tag $(BASE_IMG_TAG) .

push-base-grafana: build-base-grafana ## Push the base image to Artifactory. (Authentication Required)
	@echo Pushing Base Image
	@docker push $(BASE_IMG_TAG)

build-base-builder: ## Build the base image for Grafana Builder container
	@echo Building Base Image
	@docker build -f Base-Dockerfile-Builder --rm --tag $(BASE_BUILDER_IMG_TAG) .


build-binary: network pull-grafana patch-grafana run-builder ## Create image and run a builder container to generate all the artifacts and utilize them for Grafana

build-grafana: ## Build the customize Grafana image
	@echo Building $(CONTAINER)
	@docker build --rm -f Dockerfile-Grafana --tag $(IMG_TAG) .

##@ Run Container

module: build-base-grafana build-base-builder build-binary build-grafana run ## Execute all the requrements and run Grafana locally

run-builder: ## Run the builder image and use it to create grafana back-end and front-end artifacts
	@echo Building build container
	@docker build --rm --tag grafana-builder -f Dockerfile-Builder .
	@docker run -m 8g --name grafana-builder grafana-builder
	@docker cp grafana-builder:/go/src/grafana/bin/linux-amd64 ./build/linux-amd64
	@docker cp grafana-builder:/go/src/grafana/public ./build/public
	@docker rm -f grafana-builder
	@docker rmi -f grafana-builder
	@rm -rf src

run: ## Run the Grafana Container
	@echo Running $(CONTAINER)
	@docker run -d -it --name $(CONTAINER) --restart on-failure -p 3000:3000 --net $(NETWORK_NAME) $(IMG_TAG)


##@ Helpers

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

clean-images: ## Clean all Images
	@echo Removing Docker Images
	@docker rmi -f $(BASE_IMG_TAG)
	@docker rmi -f $(BASE_BUILDER_IMG_TAG)

pull-grafana: ## Pull the latest Grafana source code and checkout to specific used version
	@echo Building Grafana
	@rm -rf src
	@git clone $(APP_REPO) src
	@cd src && git checkout tags/$(APP_TAG)


patch-grafana: ## Apply all the patches located on build/patch directory to the source. To generate diff just use "git diff > ../build/patch/XXXX.diff" from src dir
	@echo Applying patches
	@patch -i $(shell pwd)/patch/dashboard-home.diff -d src -p 1
