#!/bin/sh

id -u app > /dev/null 2>&1

if [ $? -ne 0 ]
then
    addgroup -g $USER_GROUP_ID app
    adduser -H -D -h /var/www/html -u $USER_ID -s /bin/ash -G app app
    echo 'app:secret' | chpasswd
fi


if [[ ${1+x} ]]
then
    /usr/sbin/sshd
else
    exec /usr/sbin/sshd -D
fi


