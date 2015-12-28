#!/bin/bash
set -e

if [ "$1" = 'pure-ftpd' ]; then
    openssl req -x509 -nodes -days 7300\
        -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem\
        -subj "$PUREFTPD_CERT_SUBJ"

    chmod 600 /etc/ssl/private/pure-ftpd.pem

	(echo $PUREFTPD_PASSWORD; echo $PUREFTPD_PASSWORD) | pure-pw useradd $PUREFTPD_USER -u ftpuser -d /home/ftpuser/share
	pure-pw mkdb

	pure-ftpd -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -R -P $PUREFTPD_PASSIVE_IP -p 40000:40009 -Y 1
else
    exec "$@"
fi
