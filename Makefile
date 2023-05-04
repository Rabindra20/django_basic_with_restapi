.PHONY: help prepare-dev test lint run
.DEFAULT_GOAL := help


define BROWSER_PYSCRIPT
import webbrowser, sys

webbrowser.open(sys.argv[1])
endef
export BROWSER_PYSCRIPT

BROWSER := python3 -c "$$BROWSER_PYSCRIPT"

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([/a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-30s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

APP_ROOT ?= $(shell 'pwd')

export GIT_COMMIT ?= $(shell git rev-parse HEAD)
export GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
export DOCKER_BUILD_FLAGS ?= --no-cache
export SOURCE_IMAGE ?= django
export DOCKER_FILE ?= $(APP_ROOT)/Dockerfile
export DOCKER_BUILD_PATH ?= $(APP_ROOT)
export TARGET_IMAGE ?= $(REGISTRY_URL)/$(ECR_REPO_NAME)
export TARGET_IMAGE_LATEST ?= $(TARGET_IMAGE):$(SOURCE_IMAGE)-$(GIT_BRANCH)-$(GIT_COMMIT)

docker-build: ## build docker file
	@docker build $(DOCKER_BUILD_FLAGS) -t $(SOURCE_IMAGE):$(GIT_COMMIT) -f $(DOCKER_FILE) $(DOCKER_BUILD_PATH)

docker-tag: ## docker tag
	@docker tag $(SOURCE_IMAGE) $(TARGET_IMAGE_LATEST)

docker-push: ## docker push
	@docker push $(TARGET_IMAGE_LATEST)

run-local: ## docker run-local
	@docker run -p 8000:8000 ${IMAGE}:dev

run-app: ## docker run-app
	@docker-compose up -d

down-app: ## docker down-app
	@docker-compose down

help:
	@python3 -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)
