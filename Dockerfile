FROM php:5.6

MAINTAINER Jaroslav Hranicka <hranicka@outlook.com>

COPY bin/* /usr/local/bin/
RUN chmod -R 700 /usr/local/bin/

# PHP
	# Enable PHP extensions
	RUN apt-get update \
		&& apt-get install -y libgmp-dev \
		&& apt-get install -y libbz2-dev \
		&& apt-get install -y libfreetype6-dev \
		&& apt-get install -y libjpeg62-turbo-dev \
		&& apt-get install -y libpng12-dev \
		&& apt-get install -y libicu-dev \
		&& apt-get install -y libmcrypt-dev \
		&& apt-get install -y libxml2-dev \
		&& apt-get install -y libxslt-dev \
		&& apt-get install -y zlib1g-dev \
		&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h  \
		&& docker-php-ext-install \
			bz2 \
			bcmath \
			gmp \
			gettext \
			bz2 \
			exif \
			mbstring \
			mcrypt \
			mysqli \
			pdo_mysql \
			soap \
			sockets \
			sysvmsg \
			sysvsem \
			sysvshm \
			xmlrpc \
			xsl \
			zip \
		&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
		&& docker-php-ext-install gd \
		&& docker-php-ext-configure intl \
		&& docker-php-ext-install intl

	# XDebug
	# https://github.com/helderco/docker-php
	RUN docker-php-pecl-install xdebug-2.4.0RC3

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

	ADD php.ini /usr/local/etc/php/conf.d/docker-php.ini


# MariaDB
	RUN apt-get update \
		&& apt-get install -y software-properties-common \
		&& apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
		&& add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/debian jessie main' \
		&& apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server \
		&& mysql_install_db

	VOLUME /var/lib/mysql

	ADD my.cnf /etc/mysql/conf.d/my.cnf

	EXPOSE 3306
