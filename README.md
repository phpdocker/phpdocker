# phpdocker/phpdocker

## Usage

* Docker image is available at [Docker Hub](https://hub.docker.com/r/phpdocker/phpdocker/).
* The primary goal of this Docker image is custom image for CI, but you can obviously use it like you want.

## Example

* [Shippable CI](https://bitbucket.org/hranicka/composer-sandbox/src/master/shippable.yml?at=master&fileviewer=file-view-default) custom container

## Tags

* Tags depend on version of PHP included.
* They are given by git branches.
* You can see them at [Docker Hub](https://hub.docker.com/r/phpdocker/phpdocker/tags/).

---

## Available Bash scripts

### [check-status-code](bin/check-status-code)

This performs a HTTP Request and checks returned status code.

Returns non-zero exit code when status is not 200 (OK).

Usage: `URL="https://www.example.com" check-status-code`

## Built-in applications

* [GIT](https://git-scm.com/)
* [PHP](http://php.net) (from official [PHP Docker images](https://registry.hub.docker.com/_/php/))
	* [XDebug](http://xdebug.org)
	* [SSH2](http://php.net/ssh2)
	* [Redis](http://redis.io)
	* [APCu](http://php.net/apcu)
* [NodeJS](https://nodejs.org)
	* [Bower](http://bower.io)
* [MariaDB](https://mariadb.org)
* [Composer](https://getcomposer.org)
* [PHP_CodeSniffer](https://www.squizlabs.com/php-codesniffer) 
* [PHPUnit](https://phpunit.de)

### PHP

* PHP is started automatically.
* You can type PHP commands, eg. `php -r "echo 1;"`.
* Each Docker image contains ONLY ONE VERSION OF PHP, so:
	* If you need PHP 5.6, use `phpdocker/phpdocker:5.6`.
	* If you need PHP 7.0, use `phpdocker/phpdocker:7.0`.

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
