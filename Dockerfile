FROM ubuntu:bionic

MAINTAINER Marco Spittka <marco.spittka@rhiem.com>

RUN apt-get clean && apt-get -y update && apt-get install -y locales software-properties-common \
  && locale-gen en_US.UTF-8
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apache2 \
    apache2-utils \
    php7.4 \
    php7.4-mbstring \
    php7.4-bcmath \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    php7.4-mysql \
    php7.4-imap \
    php7.4-readline \
    php7.4-phpdbg \
    php7.4-curl \
    php7.4-dev \
    php7.4-intl \
    php7.4-gd \
    php7.4-soap \
    php-apcu \
    php7.4-xdebug \
    curl \
    zip \
    unzip \
    bzip2 \
    git \
    vim \
    less \
    ant \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Configure Apache
RUN a2enmod rewrite \
    && a2enmod ssl \
    && sed --in-place "s/^upload_max_filesize.*$/upload_max_filesize = 10M/" /etc/php/7.4/apache2/php.ini \
    && sed --in-place "s/^display_errors.*$/display_errors = On/" /etc/php/7.4/apache2/php.ini \
    && sed --in-place "s/^memory_limit.*$/memory_limit = 256M/" /etc/php/7.4/apache2/php.ini \
    && sed --in-place "s/^max_execution_time.*$/max_execution_time = 300/" /etc/php/7.4/apache2/php.ini

RUN echo "xdebug.mode = debug" >> /etc/php/7.4/apache2/php.ini \
    && echo "xdebug.max_nesting_level = 1000" >> /etc/php/7.4/apache2/php.ini \
    && echo "xdebug.start_with_request=yes" >> /etc/php/7.4/apache2/php.ini \
    && echo "xdebug.client_host=192.168.99.1" >> /etc/php/7.4/apache2/php.ini \
    && echo "xdebug.client_port = 9000" >> /etc/php/7.4/apache2/php.ini

# Install node & npm
RUN apt-get clean && apt-get update
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs


COPY ./files/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 9000