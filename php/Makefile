NS = bamarni
REPO = php
PHP_VERSION ?= 7
PHP_SAPI ?= cli

.PHONY: build

build:
	mkdir -p $(PHP_VERSION)-$(PHP_SAPI)
	echo "# auto-generated\n\nFROM php:$(PHP_VERSION)-$(PHP_SAPI)" | cat - Dockerfile.template > $(PHP_VERSION)-$(PHP_SAPI)/Dockerfile
	docker build --no-cache -f $(PHP_VERSION)-$(PHP_SAPI)/Dockerfile -t $(NS)/$(REPO):$(PHP_VERSION)-$(PHP_SAPI) .

default: build
