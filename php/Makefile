.PHONY: build

build:
	for tag in "7-cli" "7-fpm" "5-cli" "5-fpm" ; do \
		mkdir -p $$tag && cp php.ini $$tag/php.ini; \
		TAG=$$tag dockplate < Dockerfile.template > $$tag/Dockerfile; \
		mkdir -p $$tag-debug && cp php.ini $$tag-debug/php.ini; \
		TAG=$$tag XDEBUG=1 dockplate < Dockerfile.template > $$tag-debug/Dockerfile; \
	done

default: build
