#!/bin/sh

wait_for_service()
{
    local EXIT_CODE=1
    while [ $EXIT_CODE -ne 0 ]
    do
        ping -q -c1 $1 > /dev/null
        EXIT_CODE=$?
    done
}

wait_for_mysql()
{
    local EXIT_CODE=1
    while [ $EXIT_CODE -ne 0 ]
    do
        sshpass -p secret ssh -o StrictHostKeyChecking=no app@mysql \
        'mysqladmin -u root --password=secret status &> /dev/null'

        EXIT_CODE=$?
    done
}

if [ -f /var/www/html/artisan ] && [ ! -f /var/www/html/docker/bootstrap/app_is_initialized ]
then
    wait_for_service mysql && wait_for_service php-fpm && wait_for_service node

    wait_for_mysql

    sshpass -p secret ssh -o StrictHostKeyChecking=no app@php-fpm \
    'PATH=/usr/local/bin:$PATH && composer install && php artisan key:generate && php artisan migrate --seed'

    sshpass -p secret ssh -o StrictHostKeyChecking=no app@node \
    'PATH=/usr/local/bin:$PATH && yarn && yarn run production'

    echo -n > /var/www/html/docker/bootstrap/app_is_initialized
    chown $USER_ID:$USER_GROUP_ID /var/www/html/docker/bootstrap/app_is_initialized

    echo "-----------------------------"
    echo "- App has been initialized! -"
    echo "-----------------------------"
fi
