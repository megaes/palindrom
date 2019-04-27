FROM megaes/base-development

RUN apk update && \
    apk add mysql mysql-client && \
    rm -f /var/cache/apk/*

RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

VOLUME /var/lib/mysql

EXPOSE 3306


