# Docker Pure-FTPd

Docker image for [Pure-FTPd](https://www.pureftpd.org/project/pure-ftpd).

## Basic usage

With a single user :

```
docker run -d \
    -e PUREFTP_PASSIVE_IP=XXX.X.XX.X\
    -p 21:21 -p 40000-40009:40000-40009\
    -e PUREFTP_USER=user -e PUREFTP_PASSWORD=pass\
    bamarni/pureftp
```

*PUREFTP_PASSIVE_IP has to be the IP address of the machine running the container, it can also be its domain name.*

## Expose existing directory from the host

If you want to expose an existing directory from your machine, you can use a volume :

```
docker run -d \
    -e PUREFTP_PASSIVE_IP=XXX.X.XX.X\
    -p 21:21 -p 40000-40009:40000-40009\
    -v /path/in/host:/home/ftpuser/bob -e PUREFTP_BOB_PASSWORD=bobpass\
    -e PUREFTP_UID=$(id -u) -e PUREFTP_GID=$(id -g)
    bamarni/pureftp
```

Here, the user will be guessed based on the directory name under `/home/ftpuser` (bob). The environment variable
for the password is PUREFTP_(USERNAME)_PASSWORD. This allow to have multiple users.

When mounting directories, you should be careful about user mapping,
[more information here](http://blog.kaliop.com/en/blog/2015/05/27/docker-in-real-life-the-tricky-parts/#user-ids-mapping).

## FTP over TLS

To allow FTP over TLS, you can provide a certificate.

### 1) Self-signed certificate

The first solution is to create a self-signed certificate, you can provide the certificate subject like this :

```
docker run -d \
    -e PUREFTP_PASSIVE_IP=example.org\
    -p 21:21 -p 40000-40009:40000-40009\
    -e PUREFTP_CERT_SUBJ="/C=FR/O=My company/CN=example.org"\
    -e PUREFTP_USER=user -e PUREFTP_PASSWORD=pass\
    bamarni/pureftp
```

### 2) Mounting a certificate from the host

You can instead mount a certificate from the host :

```
docker run -d \
    -e PUREFTP_PASSIVE_IP=example.org\
    -p 21:21 -p 40000-40009:40000-40009\
    -v /path/to/host/certificate:/etc/ssl/private/pure-ftpd.pem\
    -e PUREFTP_USER=user -e PUREFTP_PASSWORD=pass\
    bamarni/pureftp
```
