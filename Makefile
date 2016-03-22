.PHONY: php pureftp

php:
	cd php; \
	PHP_VERSION=7 PHP_SAPI=cli make; \
	PHP_VERSION=7 PHP_SAPI=fpm make; \
	PHP_VERSION=5 PHP_SAPI=cli make; \
	PHP_VERSION=5 PHP_SAPI=fpm make;

pureftp:
	cd pureftp && make

