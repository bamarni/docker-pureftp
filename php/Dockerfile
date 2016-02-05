FROM php:7-cli

RUN apt-get update

RUN apt-get -y install git zlib1g-dev \
    && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-install zip

VOLUME /root/.composer

ENV PATH="/root/.composer/vendor/bin:$PATH"
