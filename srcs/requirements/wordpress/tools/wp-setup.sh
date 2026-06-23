#!/bin/bash

MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# me permet d attendre que MariaDB soit prêt
while ! mariadb -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT 1" &>/dev/null; do
    echo "En attente de MariaDB..."
    sleep 2
done

# me permet de télécharger WordPress si pas déjà fait
if [ ! -f /var/www/html/wp-config.php ]; then

    wp core download --path=/var/www/html --allow-root

    wp config create \
        --path=/var/www/html \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --path=/var/www/html \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    wp user create \
        ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
	--path=/var/www/html \
        --allow-root

fi

# permet d installer et configuer Redis cache

wp plugin install redis-cache --activate --path=/var/www/html --allow-root
wp config set WP_REDIS_HOST redis --path=/var/www/html --allow-root
wp config set WP_REDIS_PORT 6379 --path=/var/www/html --allow-root
wp redis enable --path=/var/www/html --allow-root

# Lance PHP-FPM en foreground (PID 1)
exec php-fpm8.2 -F
