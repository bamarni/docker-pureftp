.PHONY: build

build:
	for tag in "7-cli" "7-fpm" "5-cli" "5-fpm" ; do \
		mkdir -p $$tag; \
		cp php.ini $$tag/php.ini; \
		TAG=$$tag dockplate < Dockerfile.template > $$tag/Dockerfile; \
		cp -R $$tag $$tag-debug; \
		TAG=$$tag XDEBUG=1 dockplate < Dockerfile.template > $$tag-debug/Dockerfile; \
	done

default: build
