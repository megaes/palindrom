#!/bin/sh

cat <<EOF > ./docker/user.env
USER_ID=$(id -u)
USER_GROUP_ID=$(id -g)
EOF

if [ ! -f ./.env ]
then
    echo -n > ./.env
fi

docker-compose pull
docker-compose up -d