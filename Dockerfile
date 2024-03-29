FROM php:8.1-fpm

MAINTAINER Jaroslav Hranicka <hranicka@outlook.com>

ENV DEBIAN_FRONTEND noninteractive

COPY bin/* /usr/local/bin/
RUN chmod -R 700 /usr/local/bin/


# Locales
RUN apt-get update \
	&& apt-get install -y locales

RUN dpkg-reconfigure locales \
	&& locale-gen C.UTF-8 \
	&& /usr/sbin/update-locale LANG=C.UTF-8

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
	&& locale-gen

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


# Common
RUN apt-get update \
	&& apt-get install -y \
		openssl \
		git \
		gnupg2 \
        unzip


# PHP
# intl
RUN apt-get update \
	&& apt-get install -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install -j$(nproc) intl

# xml
RUN apt-get update \
	&& apt-get install -y \
	libxml2-dev \
	libxslt-dev \
	&& docker-php-ext-install -j$(nproc) \
		dom \
		xsl

# images
RUN apt-get update \
	&& apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	libgd-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) \
		gd \
		exif

# database
RUN docker-php-ext-install -j$(nproc) \
	mysqli \
	pdo \
	pdo_mysql

# strings
RUN apt-get update \
    && apt-get install -y libonig-dev \
    && docker-php-ext-install -j$(nproc) \
	    gettext \
	    mbstring

# math
RUN apt-get update \
	&& apt-get install -y libgmp-dev \
	&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
	&& docker-php-ext-install -j$(nproc) \
		gmp \
		bcmath

# compression
RUN apt-get update \
	&& apt-get install -y \
	libbz2-dev \
	zlib1g-dev \
	libzip-dev \
	&& docker-php-ext-install -j$(nproc) \
		zip \
		bz2

# ftp
RUN apt-get update \
	&& apt-get install -y \
	libssl-dev \
	&& docker-php-ext-install -j$(nproc) \
		ftp

# ssh2
RUN apt-get update \
	&& apt-get install -y \
	libssh2-1-dev

# memcached
RUN apt-get update \
	&& apt-get install -y \
	libmemcached-dev \
	libmemcached11


# others
RUN docker-php-ext-install -j$(nproc) \
	soap \
	sockets \
	calendar \
	sysvmsg \
	sysvsem \
	sysvshm

# PECL
RUN docker-php-pecl-install \
	ssh2-1.3.1 \
	redis-5.3.4 \
	apcu-5.1.21 \
	memcached-3.1.4

# Install XDebug, but not enable by default. Enable using:
# * php -d$XDEBUG_EXT vendor/bin/phpunit
# * php_xdebug vendor/bin/phpunit
RUN pecl install xdebug-3.1.2
ENV XDEBUG_EXT zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20201009/xdebug.so
RUN alias php_xdebug="php -d$XDEBUG_EXT vendor/bin/phpunit"

# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/local/bin/ \
	&& ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
	&& chmod 755 phpcs.phar \
	&& mv phpcs.phar /usr/local/bin/ \
	&& ln -s /usr/local/bin/phpcs.phar /usr/local/bin/phpcs \
	&& curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar \
	&& chmod 755 phpcbf.phar \
	&& mv phpcbf.phar /usr/local/bin/ \
	&& ln -s /usr/local/bin/phpcbf.phar /usr/local/bin/phpcbf

# Install PHPUnit
RUN curl -OL https://phar.phpunit.de/phpunit.phar \
	&& chmod 755 phpunit.phar \
	&& mv phpunit.phar /usr/local/bin/ \
	&& ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

ADD php.ini /usr/local/etc/php/conf.d/docker-php.ini


## NodeJS, NPM
# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# Install Grunt globally
RUN npm install -g grunt-cli

# Install Gulp globally
RUN npm install -g gulp-cli

# Install Bower globally
RUN npm install -g bower


# MariaDB
RUN apt-get update \
	&& apt-get install -y software-properties-common dirmngr \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
	&& add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.6/debian bullseye main' \
    && apt-get update && apt-get install -y mariadb-server galera-4 mariadb-client libmariadb3 mariadb-backup mariadb-common

VOLUME /var/lib/mysql

ADD my.cnf /etc/mysql/conf.d/my.cnf

EXPOSE 3306


# Redis
RUN apt-get update \
	&& apt-get install -y redis-server

EXPOSE 6379


# Clean
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*
