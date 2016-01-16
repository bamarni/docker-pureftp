FROM debian:jessie

ENV PUREFTP_VERSION 1.0.42

RUN apt-get update

RUN apt-get -y install wget build-essential libssl-dev openssl \
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
    && rm -rf /var/lib/apt/lists/* /tmp*

RUN groupadd ftpgroup && useradd -g ftpgroup -d /home/ftpuser -m -s /dev/null ftpuser

RUN mkdir -p /etc/ssl/private/

VOLUME /home/ftpuser

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["pure-ftpd"]

EXPOSE 21
