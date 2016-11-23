.DEFAULT_GOAL  := help
.PHONY         : help test clean build repl run
docker         := $(shell command -v docker 2> /dev/null)
docker-compose := $(shell command -v docker-compose 2> /dev/null)
NODE_BIN        = $(shell npm bin --loglevel silent)
THIS_FILE_PATH :=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_DIR       :=$(shell cd $(dir $(THIS_FILE_PATH));pwd)
THIS_MAKEFILE  :=$(notdir $(THIS_FILE_PATH))

clean:
	@git clean -x -f
	@rm -f dist/*

check-deps: ## Check if we have required dependencies
ifndef docker
	@echo "I couldn't find the docker command, install from www.docker.com"
endif
ifndef docker-compose
	@echo "I couldn't find the docker-compose command, install from www.docker.com"
endif
	@docker info >/dev/null

# the stuff to the right of the pipe symbol is order-only prerequisites
test: check-deps ## Run the tests
	@npm run-script test

build: check-deps ## Compile elm app
	@npm run-script build

repl: check-deps ## Compile elm app
	@npm run-script repl

run: check-deps ## Run elm app in dev mode and open browser
	@npm run-script start

shasums:
	@sudo sh -c 'sha256sum dist/* > bin/SHA256_SUMS.txt'

# cleverness from http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show the help for this makefile
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
