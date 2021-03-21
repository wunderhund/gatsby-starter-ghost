
INTERACTIVE := $(shell [ -t 0 ] && echo -it)
ENV_FILE := .env.development

DOCKER_TAG := ggjam-frontend
DOCKER_NETWORK := ggjam-backend_ggjam
DOCKER_ARGS := -v $(shell pwd):/app $(INTERACTIVE) \
							 --env-file $(ENV_FILE) \
							 --network $(DOCKER_NETWORK) \
							 --rm --init
BASH := docker run $(DOCKER_ARGS) $(DOCKER_TAG) /bin/bash

.PHONY: init
init: create-network
	docker build -t $(DOCKER_TAG) .
	$(BASH) -c 'yarn'

.PHONY: dev
dev: create-network clean
	docker run $(DOCKER_ARGS) -p 8000:8000 -t $(DOCKER_TAG) /bin/bash -c 'gatsby develop -H "0.0.0.0"'

.PHONY: package
package: create-network clean
	$(BASH) -c 'gatsby build'
	$(BASH) -c 'tar -cvf frontend.tar public'

.PHONY: serve
serve: package
	docker run $(DOCKER_ARGS) -p 9000:9000 --init -t $(DOCKER_TAG) /bin/bash -c 'gatsby serve -H "0.0.0.0"'

.PHONY: clean
clean: create-network
	$(BASH) -c 'gatsby clean'
	$(BASH) -c 'rm -f frontend.tar'

.PHONY: shell
shell: create-network
	$(BASH)

.PHONY: create-network
create-network:
	@docker network inspect $(DOCKER_NETWORK) 1>/dev/null || docker network create --driver bridge $(DOCKER_NETWORK)
