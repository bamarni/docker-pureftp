#!/bin/bash
set -e

if [ "$1" = 'pure-ftpd' ]; then
    if [ -n "$PUREFTP_CERT_SUBJ" ]; then
        echo "Creating self-signed certificate..."
        openssl req -x509 -nodes -days 7300\
            -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem\
            -subj "$PUREFTP_CERT_SUBJ"

        chmod 600 /etc/ssl/private/pure-ftpd.pem
    fi

    if [ -f /etc/ssl/private/pure-ftpd.pem ]; then
        echo "TLS will be enabled."
        set -- "$@" -Y 1
    fi

    # http://blog.kaliop.com/en/blog/2015/05/27/docker-in-real-life-the-tricky-parts/#user-ids-mapping
    if [ -n "$PUREFTP_UID" -a -n "$PUREFTP_GID" ]; then
        echo "Configuring user mapping..."
        groupmod -o --gid $PUREFTP_GID ftpgroup
        usermod -o --uid $PUREFTP_UID --gid $PUREFTP_GID ftpuser
        chown -R ftpuser:ftpgroup /home/ftpuser
    fi

    if [ -n "$PUREFTP_USER" -a -n "$PUREFTP_PASSWORD" ]; then
        echo "Adding user \"$PUREFTP_USER\"..."
        mkdir /home/ftpuser/$PUREFTP_USER
        chown ftpuser:ftpgroup /home/ftpuser/$PUREFTP_USER
        pure-pw show $user || (echo $PUREFTP_PASSWORD; echo $PUREFTP_PASSWORD) | pure-pw useradd $PUREFTP_USER -u ftpuser -d /home/ftpuser/$PUREFTP_USER
    else
        for user in $(ls -l /home/ftpuser | awk '/^d/{print $9}'); do
            echo "Adding user \"$user\"..."
            password=PUREFTP_$(echo $user | tr '[:lower:]' '[:upper:]')_PASSWORD
            if [ -z "${!password}" ]; then
                echo >&2 "$password is not defined."
                exit 1
            fi
            pure-pw show $user || (echo ${!password}; echo ${!password}) | pure-pw useradd $user -u ftpuser -g ftpgroup -d /home/ftpuser/$user >/dev/null
        done
    fi

    echo "Creating users database..."
    pure-pw mkdb

    echo "Symlinking /dev/log for Syslog..."
    ln -sf /var/run/rsyslog/dev/log /dev/log

    echo "Preparing FIFO for access logs..."
    [[ -p /var/log/pureftpd.log ]] || mkfifo /var/log/pureftpd.log
    tail -f /var/log/pureftpd.log &

    echo "Starting Pure-FTPd..."
    exec "$@" -E -R \
        -l puredb:/etc/pureftpd.pdb \
        -P $PUREFTP_PASSIVE_IP \
        -p 40000:40009 \
        -u ${PUREFTP_MIN_UID:-1000} \
        -O clf:/var/log/pureftpd.log
else
    exec "$@"
fi
