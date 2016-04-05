TAG ?= 7-cli

.PHONY: build

build:
	for tag in "7-cli" "7-fpm" "5-cli" "5-fpm" ; do \
		mkdir -p $$tag; \
		cp php.ini $$tag/php.ini; \
		TAG=$$tag dockplate < Dockerfile.template > $$tag/Dockerfile; \
	done
default: build
