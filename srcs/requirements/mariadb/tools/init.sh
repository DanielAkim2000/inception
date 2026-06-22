#!/bin/bash

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Crée le dossier pour le socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Init la BDD si premier démarrage
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Lance MariaDB en background pour la config initiale
mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
MYSQLD_PID=$!

# Attend que le socket soit prêt
while [ ! -S /run/mysqld/mysqld.sock ]; do
    sleep 1
done

# Configure la BDD
mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Arrête le MariaDB temporaire proprement
kill $MYSQLD_PID
wait $MYSQLD_PID

# Lance MariaDB en foreground PID 1
exec mysqld --user=mysql
