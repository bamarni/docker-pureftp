FROM debian:jessie

RUN apt-get update && apt-get -y install pure-ftpd openssl && rm -rf /var/lib/apt/lists/*

RUN groupadd ftpgroup && useradd -g ftpgroup -d /home/ftpuser -m -s /dev/null ftpuser

RUN mkdir -p /etc/ssl/private/

VOLUME /home/ftpuser

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["pure-ftpd"]

EXPOSE 21
