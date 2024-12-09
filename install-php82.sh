#!/bin/bash

#PHP
####################################
version=8.2.12
####################################
echo $version version will be installed
#version=8.2.12
base=/root/deploy

sudo apt install -y nano wget tar zip make build-essential git curl gcc g++ autoconf pkg-config libxml2-dev zlib1g-dev sqlite3 bzip2 libbz2-dev libcurl4-openssl-dev libssl-dev libgmp-dev libonig-dev libsqlite3-dev libxslt-dev

sudo apt update
mkdir -p /root/sw/php
wget https://www.php.net/distributions/php-$version.tar.gz -O /root/sw/php/php-$version.tar.gz
tar vfx /root/sw/php/php-$version.tar.gz -C /root/sw/php
cd /root/sw/php/php-$version
./buildconf --force
./configure --prefix=/opt/php-$version OPENSSL_CFLAGS=-I/opt/openssl/include/ OPENSSL_LIBS="-L/opt/openssl/lib64/ -lssl -lcrypto" \
    --enable-fpm \
    --enable-bcmath \
    --with-config-file-path=/opt/php-$version/etc \
    --enable-cli \
    --enable-sockets \
    --with-zlib \
    --enable-dom \
    --enable-exif \
    --enable-fileinfo \
    --enable-ftp \
    --with-iconv \
    --enable-mbstring \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-pcntl \
    --enable-posix \
    --enable-xmlreader \
    --with-xsl \
    --with-gmp \
    --enable-intl \
    --enable-simplexml \
    --with-curl \
    --with-libdir=lib64 \
    --enable-soap \
    --with-openssl \
    --with-pear

# removed:     --with-zlib \     --with-bz2 \     --with-pdo-pgsql=/usr/pgsql-14 \

make && make install
ln -s /opt/php-$version /opt/php

### PHP INSTALL DONE



echo 'export PATH=$PATH:/opt/php/bin/' >> /root/.bashrc
/opt/php/bin/pecl channel-update pecl.php.net

# install redis php extension (later add redis.so to php.ini)
echo '' | /opt/php/bin/pecl install redis

# install swoole
echo '' | /opt/php/bin/pecl install swoole

# Copy php.ini
cp $base/templates/php/php.ini /opt/php/etc/php.ini

#echo 'extension=redis.so' >> /opt/php/etc/php.ini
#echo 'extension=swoole.so' >> /opt/php/etc/php.ini

# FPM INSTALLATION SAMPLE:
#cp $base/templates/php-fpm/php-fpm.service /etc/systemd/system/php-fpm.service
#systemctl daemon-reload
#systemctl enable php-fpm
#systemctl start php-fpm

# make php command avaliable
ln /opt/php/bin/php /usr/bin/php

