FROM ubuntu:bionic

MAINTAINER Marco Spittka <marco.spittka@rhiem.com>

RUN apt-get clean && apt-get -y update && apt-get install -y locales software-properties-common \
  && locale-gen en_US.UTF-8
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apache2 \
    apache2-utils \
    php7.3 \
    php7.3-mbstring \
    php7.3-bcmath \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-zip \
    php7.3-sqlite3 \
    php7.3-mysql \
    php7.3-pgsql \
    php7.3-imap \
    php7.3-readline \
    php7.3-phpdbg \
    php7.3-curl \
    php7.3-dev \
    php7.3-intl \
    php7.3-gd \
    php-apcu \
    php-xdebug \
    curl \
    unzip \
    bzip2 \
    git \
    vim \
    less \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
# Configure Apache

RUN a2enmod rewrite \
    && a2enmod ssl \
    && sed --in-place "s/^upload_max_filesize.*$/upload_max_filesize = 10M/" /etc/php/7.3/apache2/php.ini \
    && sed --in-place "s/^display_errors.*$/display_errors = On/" /etc/php/7.3/apache2/php.ini \
    && sed --in-place "s/^memory_limit.*$/memory_limit = 256M/" /etc/php/7.3/apache2/php.ini

RUN echo "xdebug.remote_enable = 1" >> /etc/php/7.3/apache2/php.ini \
    && echo "xdebug.remote_connect_back = 1" >> /etc/php/7.3/apache2/php.ini \
    && echo "xdebug.remote_port = 9000" >> /etc/php/7.3/apache2/php.ini


COPY files/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 9000