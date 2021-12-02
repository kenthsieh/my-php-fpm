################################
#                              #
#   Ubuntu - PHP 7.3 CLI+FPM   #
#                              #
################################

FROM ubuntu:bionic

MAINTAINER Kent Hsieh <https://github.com/kenthsieh/php-fpm.git>

LABEL Vendor="kenthsieh"
LABEL Description="PHP-FPM"
LABEL Version="7.3"

ENV TIMEZONE Asia/Taipei

# Set linux timezone
RUN echo $TIMEZONE | tee /etc/timezone

RUN apt-get update -yqq && DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN DEBIAN_FRONTEND=noninteractive LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update -yqq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
	ca-certificates \
    tzdata \
    build-essential \
    openssh-client \
    git \
    vim \
    gcc \
    make \
    wget \
    curl 

## Install php7.3 extension
RUN apt-get update -yqq \
    && apt-get install -yqq \
    php7.3-pgsql \
	php7.3-mysql \
	php7.3-opcache \
	php7.3-common \
	php7.3-mbstring \
	php7.3-soap \
	php7.3-cli \
	php7.3-intl \
	php7.3-json \
	php7.3-xsl \
	php7.3-imap \
	php7.3-ldap \
	php7.3-curl \
	php7.3-gd  \
	php7.3-dev \
    php7.3-fpm \
    php7.3-bcmath \
    php7.3-imagick \
    php7.3-zip \
    php7.3-zmq \
    php7.3-apcu \
    && apt-get install pkg-config \
    && pecl install mongodb \
    && echo "extension=mongodb.so" > /etc/php/7.3/cli/conf.d/ext-mongodb.ini \
    && echo "extension=mongodb.so" > /etc/php/7.3/fpm/conf.d/ext-mongodb.ini \
    && apt-get install -y -q --no-install-recommends ssmtp

RUN apt-get autoclean    

# Add PHP default timezone
RUN echo "date.timezone=$TIMEZONE" > /etc/php/7.3/cli/conf.d/timezone.ini

## Install composer globally
RUN echo "Install composer globally"
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Copy our config files for php7.3 fpm and php7.3 cli
COPY php-conf/php.ini /etc/php/7.3/cli/php.ini
COPY php-conf/php-fpm.ini /etc/php/7.3/fpm/php.ini
COPY php-conf/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
COPY php-conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

WORKDIR /var/www/html

EXPOSE 9000
