FROM debian:jessie-backports

RUN apt-get update \
  && apt-get install -y letsencrypt -t jessie-backports \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY default.conf /etc/letsencrypt/default.conf

VOLUME /var/www/letsencrypt
