# phpdocker/phpdocker

## Available applications

* [PHP](http://php.net) (from official [PHP Docker images](https://registry.hub.docker.com/_/php/))
* [MariaDB](https://mariadb.org)
* [Redis](http://redis.io)
* [APCu](http://php.net/apcu)
* [Composer](https://getcomposer.org)
* [PHP_CodeSniffer](https://www.squizlabs.com/php-codesniffer) 
* [PHPUnit](https://phpunit.de)

## Usage

### PHP

* PHP is started automatically
* you can type PHP commands, eg. ´php -r "echo 1;"´

### MariaDB

* MariaDB is not started automatically
* type ´service mysql start´ first
* then you can work with DB, eg. ´mysql -e 'create database test;'´

### Redis

* Redis is not started automatically
* type ´service redis-server start´ first
* then you can work with DB, eg. ´redis-cli ping´

### Composer

* Composer is installed globally
* you can run it, eg. ´composer self-update´

### PHP_CodeSniffer

* PHP_CodeSniffer is installed globally
* you can run it, eg. ´phpcs --standard=PSR2 -nsp src tests´

### PHPUnit

* PHPUnit is installed globally
* you can run it, eg. ´phpunit --log-junit shippable/testresults/junit.xml --coverage-xml shippable/codecoverage -c tests/configuration.xml tests´
