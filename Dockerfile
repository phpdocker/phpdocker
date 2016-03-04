FROM php:7.0-fpm

MAINTAINER Jaroslav Hranicka <hranicka@outlook.com>

COPY bin/* /usr/local/bin/
RUN chmod -R 700 /usr/local/bin/

# PHP
	RUN apt-get update \
		&& apt-get install -y openssl

	# intl
	RUN apt-get update \
		&& apt-get install -y libicu-dev \
		&& docker-php-ext-configure intl \
		&& docker-php-ext-install intl

	# xml
	RUN apt-get update \
		&& apt-get install -y \
		libxml2-dev \
		libxslt-dev \
		&& docker-php-ext-install \
			dom \
			xmlrpc \
			xsl

	# images
	RUN apt-get update \
		&& apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libgd-dev \
		&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
		&& docker-php-ext-install \
			gd \
			exif

	# database
	RUN docker-php-ext-install \
		mysqli \
		pdo \
		pdo_mysql

	# mcrypt
	RUN apt-get update \
		&& apt-get install -y libmcrypt-dev \
		&& docker-php-ext-install mcrypt

	# strings
	RUN docker-php-ext-install \
		gettext \
		mbstring

	# math
	RUN apt-get update \
		&& apt-get install -y libgmp-dev \
		&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
		&& docker-php-ext-install \
			gmp \
			bcmath

	# compression
	RUN apt-get update \
		&& apt-get install -y \
		libbz2-dev \
		zlib1g-dev \
		&& docker-php-ext-install \
			zip \
			bz2

	# others
	RUN docker-php-ext-install \
		soap \
		sockets \
		sysvmsg \
		sysvsem \
		sysvshm

	# PECL
	RUN docker-php-pecl-install \
		xdebug-2.4.0RC4 \
		redis \
		apcu

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


# MariaDB
	RUN apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server \
		&& mysql_install_db

	VOLUME /var/lib/mysql

	ADD my.cnf /etc/mysql/conf.d/my.cnf

	EXPOSE 3306


# Redis
	RUN apt-get update \
		&& apt-get install -y redis-server

	EXPOSE 6379
