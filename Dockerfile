FROM debian:jessie

ARG PUREFTP_VERSION

RUN apt-get update \
    && apt-get -y install wget build-essential libssl-dev openssl \
    && cd /tmp \
    && wget ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$PUREFTP_VERSION.tar.gz \
    && wget ftp://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-$PUREFTP_VERSION.tar.gz.sig \
    && gpg --keyserver keys.gnupg.net --recv-keys 2B6F76DA \
    && gpg --verify pure-ftpd-$PUREFTP_VERSION.tar.gz.sig \
    && tar zxvf pure-ftpd-$PUREFTP_VERSION.tar.gz \
    && cd pure-ftpd-$PUREFTP_VERSION \
    && ./configure \
        --with-altlog \
        --with-puredb \
        --with-tls \
        --without-capabilities \
    && make \
    && make install \
    && apt-get -y purge wget build-essential libssl-dev \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && groupadd ftpgroup && useradd -g ftpgroup -d /home/ftpuser -m -s /dev/null ftpuser \
    && mkdir -p /etc/ssl/private

VOLUME /home/ftpuser

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["pure-ftpd"]

EXPOSE 21
