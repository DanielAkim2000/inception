FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
    wget -O /var/www/html/adminer.php \
    https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

COPY conf/adminer.conf /etc/php/8.2/fpm/pool.d/adminer.conf
COPY tools/adminer.sh /adminer.sh
RUN chmod +x /adminer.sh

EXPOSE 9001

ENTRYPOINT ["/adminer.sh"]
