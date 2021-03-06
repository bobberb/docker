FROM alpine:edge
MAINTAINER Marvin Steadfast <marvin@xsteadfastx.org>

ENV WALLABAG_VERSION=2.1.1 \
    SYMFONY__ENV__DATABASE_DRIVER=pdo_sqlite \
    SYMFONY__ENV__DATABASE_HOST=127.0.0.1 \
    SYMFONY__ENV__DATABASE_PORT=~ \
    SYMFONY__ENV__DATABASE_NAME=symfony \
    SYMFONY__ENV__DATABASE_USER=root \
    SYMFONY__ENV__DATABASE_PASSWORD=~ \
    POSTGRES_USER=postgres \
    SYMFONY__ENV__SECRET=ovmpmAWXRCabNlMgzlzFXDYmCFfzGv \
    SYMFONY__ENV__MAILER_HOST=127.0.0.1 \
    SYMFONY__ENV__MAILER_USER=~ \
    SYMFONY__ENV__MAILER_PASSWORD=~ \
    SYMFONY__ENV__FROM_EMAIL=wallabag@example.com


RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk add --update \
      ansible \
      curl \
      git \
      libwebp@testing \
      mariadb-client \
      nginx \
      pcre \
      php7 \
      php7-amqp@testing \
      php7-bcmath \
      php7-ctype@testing \
      php7-curl@testing \
      php7-dom@testing \
      php7-fpm@testing \
      php7-gd@testing \
      php7-gettext@testing \
      php7-iconv@testing \
      php7-json@testing \
      php7-mbstring@testing \
      php7-openssl@testing \
      php7-pdo_mysql@testing \
      php7-pdo_pgsql@testing \
      php7-pdo_sqlite@testing \
      php7-phar@testing \
      php7-session@testing \
      php7-xml@testing \
      php7@testing\
      py-mysqldb \
      py-psycopg2 \
      py-simplejson \
      s6 \
      tar \
 && rm -rf /var/cache/apk/*

RUN ln -s /usr/bin/php7 /usr/bin/php \
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

RUN curl -s http://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer

RUN git clone --branch $WALLABAG_VERSION --depth 1 https://github.com/wallabag/wallabag.git /var/www/wallabag

COPY root /

RUN cd /var/www/wallabag \
 && SYMFONY_ENV=prod composer install --no-dev -o --prefer-dist

RUN chown -R nobody:nobody /var/www/wallabag

RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["wallabag"]
