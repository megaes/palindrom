#!/bin/sh

./docker/base/start.sh $$

if [ "$DB_DATABASE" == "" ] || [ "$DB_USERNAME" == "" ] || [ "$DB_PASSWORD" == "" ]
then
    return 0
fi

if [ ! -d /var/lib/mysql/mysql ]
then
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	# init database
	echo 'Initializing database'
	mysql_install_db --user=mysql > /dev/null
	echo 'Database initialized'

    DB_ROOT_PASSWORD='secret'

	echo "[i] MySql root password: $DB_ROOT_PASSWORD"

	# create temp file
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	# save sql
	echo "[i] Create temp file: $tfile"
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION;
EOF

	# Create new database
    echo "[i] Creating database: $DB_DATABASE"
    echo "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile

    # set new User and Password
    echo "[i] Creating user: $DB_USERNAME with password $DB_PASSWORD"
    echo "GRANT ALL ON \`$DB_DATABASE\`.* to '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD';" >> $tfile

	echo 'FLUSH PRIVILEGES;' >> $tfile

	# run sql in tempfile
	echo "[i] run tempfile: $tfile"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi

echo "[i] Sleeping 5 sec"
sleep 5

echo '[i] start running mysqld'
exec /usr/bin/mysqld --user=mysql --console




