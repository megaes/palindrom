FROM alpine:3.8

RUN apk add --update --no-cache curl git openssh-server && \
    /usr/bin/ssh-keygen -A

WORKDIR /var/www/html