FROM php:7-cli

# Dependencies
#   bz2 extension : libbz2-dev
#   composer : git (to install packages from source)
#   gd extension : libpng12-dev
#   intl extension : libicu-dev
#   soap extension : libxml2-dev
#   zip extension : zlib1g-dev

RUN apt-get update \
    && apt-get -y install git libbz2-dev libicu-dev libpng12-dev libxml2-dev zlib1g-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install bz2 gd intl mbstring opcache pcntl soap sockets zip \
    && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && echo "opcache.enable_cli=1" >> $PHP_INI_DIR/conf.d/docker-php-ext-opcache.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/lib/apt/lists/*

VOLUME /root/.composer

ENV PATH="/root/.composer/vendor/bin:$PATH"
