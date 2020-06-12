MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

ENVIRONMENT ?= dev
ARGS =
APP_NAME = $(shell python -m src.config app_name)
SOURCE_DIR = src
TEST_DIR = tests

IMAGE_HOST := docker.io
IMAGE_REPO := yxtay
IMAGE_NAME := $(IMAGE_HOST)/$(IMAGE_REPO)/$(APP_NAME)
IMAGE_TAG ?= latest

.PHONY: help
help:  ## print help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## dependencies

.PHONY: requirements-update
requirements-update:  ## update requirements
	pip install --upgrade pip setuptools pip-tools
	pip-compile --upgrade --build-isolation --output-file requirements/main.txt requirements/main.in
	pip-compile --upgrade --build-isolation --output-file requirements/dev.txt requirements/dev.in

.PHONY: requirements-install
requirements-install:  ## install requirements
	pip install --upgrade pip
	pip install -r requirements/main.txt -r requirements/dev.txt

## checks

.PHONY: format
format:  ## format python
	black $(SOURCE_DIR) $(TEST_DIR)

.PHONY: lint
lint:  ## lint python
	black $(SOURCE_DIR) $(TEST_DIR) --diff
	isort --check-only
	flake8 $(SOURCE_DIR) $(TEST_DIR)
	mypy $(SOURCE_DIR)

.PHONY: test
test:  ## test python
	pytest $(TEST_DIR) --cov $(SOURCE_DIR)

.PHONY: run-ci
run-ci: requirements-install lint test  ## run ci

## app

.PHONY: run-task
run-task:  ## run python task
	python -m src.task

.PHONY: run-web-dev
run-web-dev:
	python -m src.web

.PHONY: run-web
run-web:  ## run python web
	gunicorn src.web:app -c src/gunicorn_conf.py

## docker

.PHONY: docker-build
docker-builder:
	docker pull $(IMAGE_NAME):builder || true
	docker build . \
		--build-arg ENVIRONMENT=$(ENVIRONMENT) \
		--cache-from $(IMAGE_NAME):builder \
		--tag $(IMAGE_NAME):builder \
		--target builder

.PHONY: docker-build
docker-build:  ## build app image
	docker pull $(IMAGE_NAME):builder || true
	docker pull $(IMAGE_NAME):latest || true
	docker build . \
		--build-arg ENVIRONMENT=$(ENVIRONMENT) \
		--cache-from $(IMAGE_NAME):builder \
		--cache-from $(IMAGE_NAME):latest \
		--tag $(IMAGE_NAME):$(IMAGE_TAG) \
		--target app

.PHONY: docker-push
docker-push:  ## push app image
	docker push $(IMAGE_NAME):builder || true
	docker push $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: docker-run
docker-run:  ## run app image
	docker run --rm \
		-e ENVIRONMENT=$(ENVIRONMENT) \
		-p 8000:8000 \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		$(ARGS)

.PHONY: docker-exec
docker-exec:
	docker exec -it \
		$(shell docker ps -q  --filter ancestor=$(IMAGE_NAME):$(IMAGE_TAG)) \
		/bin/bash

.PHONY: docker-stop
docker-stop:
	docker stop \
	  $(shell docker ps -q  --filter ancestor=$(IMAGE_NAME):$(IMAGE_TAG))
