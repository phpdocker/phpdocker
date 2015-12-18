FROM php:5.4

MAINTAINER Jaroslav Hranicka <hranicka@outlook.com>


# PHP
	# Enable PHP extensions
	RUN apt-get update \
		&& apt-get install -y libpng12-dev \
		&& apt-get install -y libicu-dev \
		&& apt-get install -y libmcrypt-dev \
		&& apt-get install -y libxml2-dev \
		&& apt-get install -y zlib1g-dev \
		&& docker-php-ext-install bcmath exif gd intl mbstring mcrypt mysqli pdo pdo_mysql soap zip

	# Install XDebug
	# https://gist.github.com/chadrien/c90927ec2d160ffea9c4
	RUN apt-get install -y php5-xdebug \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

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


# MariaDB
	RUN apt-get update \
		&& apt-get install -y software-properties-common \
		&& apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db \
		&& add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/10.0/debian jessie main' \
		&& apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server \
		&& mysql_install_db

	VOLUME /var/lib/mysql

	EXPOSE 3306
