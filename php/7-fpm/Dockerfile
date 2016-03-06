# auto-generated

FROM php:7-fpm

# Dependencies
#   bz2 extension :       libbz2-dev
#   composer :            git (to install packages from source)
#   gd extension :        libpng12-dev
#   intl extension :      libicu-dev
#   pdo_pgsql extension : libpq-dev
#   soap extension :      libxml2-dev
#   zip extension :       zlib1g-dev

RUN apt-get update \
    && apt-get -y install \
        git \
        libbz2-dev \
        libicu-dev \
        libpng12-dev \
        libpq-dev \
        libxml2-dev \
        zlib1g-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
        bz2 \
        gd \
        intl \
        mbstring \
        opcache \
        pcntl \
        pdo_pgsql \
        soap \
        sockets \
        zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY php.ini $PHP_INI_DIR/conf.d/php.ini

VOLUME /root/.composer

ENV PATH="/root/.composer/vendor/bin:$PATH"
