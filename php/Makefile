NS = bamarni
REPO = php
VERSION ?= latest
PHP_VERSION ?= 7

.PHONY: build

build:
	mkdir -p $(PHP_VERSION)
	echo "# auto-generated\n\nFROM php:$(PHP_VERSION)-cli" | cat - Dockerfile.template > $(PHP_VERSION)/Dockerfile

default: build
