FROM php:7-cli

# Dependencies
#   composer : git (to install packages from source)
#   gd extension : libpng12-dev
#   intl extension : libicu-dev
#   soap extension : libxml2-dev
#   zip extension : zlib1g-dev

RUN apt-get update \
    && apt-get -y install git libicu-dev libpng12-dev libxml2-dev zlib1g-dev \
    && echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-configure intl \
    && docker-php-ext-install gd intl mbstring soap zip \
    && rm -rf /var/lib/apt/lists/*

VOLUME /root/.composer

ENV PATH="/root/.composer/vendor/bin:$PATH"
