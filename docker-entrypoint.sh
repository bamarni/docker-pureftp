#!/bin/bash
set -e

if [ "$1" = 'pure-ftpd' ]; then
    if [ -n "$PUREFTP_CERT_SUBJ" ]; then
        openssl req -x509 -nodes -days 7300\
            -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem\
            -subj "$PUREFTP_CERT_SUBJ"

        chmod 600 /etc/ssl/private/pure-ftpd.pem
    fi

    if [ -f /etc/ssl/private/pure-ftpd.pem ]; then
        set -- "$@" -Y 1
    fi

    if [ -n "$PUREFTP_USER" -a -n "$PUREFTP_PASSWORD" ]; then
        mkdir /home/ftpuser/$PUREFTP_USER
        chown ftpuser:ftpgroup /home/ftpuser/$PUREFTP_USER
        (echo $PUREFTP_PASSWORD; echo $PUREFTP_PASSWORD) | pure-pw useradd $PUREFTP_USER -u ftpuser -d /home/ftpuser/$PUREFTP_USER
    else
        for user in $(ls -l /home/ftpuser | awk '/^d/{print $9}'); do
            password=PUREFTP_$(echo $user | tr '[:lower:]' '[:upper:]')_PASSWORD
            if [ -z "${!password}" ]; then
                echo >&2 "$password is not defined."
                exit 1
            fi
            (echo ${!password}; echo ${!password}) | pure-pw useradd $user -u ftpuser -d /home/ftpuser/$user
        done
    fi

    pure-pw mkdb

    # http://blog.kaliop.com/en/blog/2015/05/27/docker-in-real-life-the-tricky-parts/#user-ids-mapping
    if [ -n "$PUREFTP_UID" -a -n "$PUREFTP_GID" ]; then
        groupmod -o --gid $PUREFTP_GID ftpgroup
        usermod -o --uid $PUREFTP_UID --gid $PUREFTP_GID ftpuser
        chown -R ftpuser:ftpgroup /home/ftpuser
    fi

    exec "$@" -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -R -P $PUREFTP_PASSIVE_IP -p 40000:40009
else
    exec "$@"
fi
