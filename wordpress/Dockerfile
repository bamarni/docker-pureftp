FROM bamarni/php:7-fpm

RUN docker-php-ext-install mysqli

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD php-fpm
