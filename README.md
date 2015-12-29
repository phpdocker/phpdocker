# phpdocker/phpdocker

## Usage

### Pull Docker image

```bash

$ docker pull phpdocker/phpdocker
```

### Available tags

* Tags depend on version of PHP included.
* They are given by git branches.
* You can see them at [Docker Hub](https://hub.docker.com/r/phpdocker/phpdocker/tags/).

### 

## Available applications

* [PHP](http://php.net) (from official [PHP Docker images](https://registry.hub.docker.com/_/php/))
* [MariaDB](https://mariadb.org)
* [Redis](http://redis.io)
* [APCu](http://php.net/apcu)
* [Composer](https://getcomposer.org)
* [PHP_CodeSniffer](https://www.squizlabs.com/php-codesniffer) 
* [PHPUnit](https://phpunit.de)

### PHP

* PHP is started automatically.
* You can type PHP commands, eg. `php -r "echo 1;"`.

### MariaDB

* MariaDB is not started automatically.
* Type `service mysql start` if you want start it.
* Then you can work with DB, eg. `mysql -e 'create database test;'`.
* Default mysql user is `root` without password.

### Redis

* Redis is not started automatically.
* Type `service redis-server start` if you want start it.
* Then you can work with DB, eg. `redis-cli ping`.

### Composer

* Composer is installed globally.
* You can run it, eg. `composer self-update`.

### PHP_CodeSniffer

* PHP_CodeSniffer is installed globally.
* You can run it, eg. `phpcs --standard=PSR2 -nsp src tests`.

### PHPUnit

* PHPUnit is installed globally.
* You can run it, eg. `phpunit --log-junit shippable/testresults/junit.xml --coverage-xml shippable/codecoverage -c tests/configuration.xml tests`.
