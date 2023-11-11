#!/bin/bash

#PHP
####################################
version=8.2.12
####################################
echo $version version will be installed
#version=8.2.12
base=/root/deploy

sudo apt install -y nano wget tar make build-essential git curl gcc g++ autoconf pkg-config libxml2-dev zlib1g-dev sqlite bzip2 libbz2-dev libcurl4-openssl-dev libssl-dev libgmp-dev libonig-dev libsqlite3-dev libxslt-dev

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
    --without-sqlite3 \
    --without-pdo-sqlite \
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

# removed:     --with-zlib \     --with-bz2 \

make && make install
ln -s /opt/php-$version /opt/php












# OLD BELOW

yum install -y epel-release

yum install -y nano wget tar pcre-devel openssl-devel gcc autoconf libxml2-devel bzip2-devel curl-devel libjpeg-devel libcurl-devel libjpeg-turbo-devel libpng-devel libicu-devel libmcrypt-devel mysql libxslt-devel gcc-c++ sqlite-devel freetype freetype-devel systemd-devel oniguruma

yum -y --enablerepo=powertools install oniguruma-devel

# for gmp
yum -y install gmp gmp-devel

yum -y install make

yum update

mkdir -p /root/sw/php
wget https://www.php.net/distributions/php-$version.tar.gz -O /root/sw/php/php-$version.tar.gz
tar vfx /root/sw/php/php-$version.tar.gz -C /root/sw/php
cd /root/sw/php/php-$version
./buildconf --force
./configure --prefix=/opt/php-$version \
    --enable-fpm \
    --with-config-file-path=/opt/php-$version/etc \
    --enable-cli \
    --enable-sockets \
    --with-bz2 \
    --enable-dom \
    --enable-exif \
    --enable-fileinfo \
    --enable-ftp \
    --with-iconv \
    --enable-mbstring \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-pgsql=/usr/pgsql-14 \
    --enable-pcntl \
    --enable-posix \
    --enable-xmlreader \
    --with-xsl \
    --with-zlib \
    --with-gmp \
    --enable-intl \
    --enable-simplexml \
    --with-curl \
    --with-libdir=lib64 \
    --enable-soap \
    --with-openssl \
    --with-pear
make && make install
ln -s /opt/php-$version /opt/php
######################################



# copy main config file
cp /opt/php/etc/php-fpm.conf.default /opt/php/etc/php-fpm.conf
# copy default pool
cp $base/templates/php-fpm/default-pool.conf /opt/php/etc/php-fpm.d/default-pool.conf

echo 'export PATH=$PATH:/opt/php/bin/' >> /root/.bashrc

cp $base/templates/php-fpm/php-fpm.service /etc/systemd/system/php-fpm.service

/opt/php/bin/pecl channel-update pecl.php.net

# install mongodb php extension
# /opt/php/bin/pecl install mongodb

# install redis php extension
echo '' | /opt/php/bin/pecl install redis

# install imagick php extension
# echo '' | /opt/php/bin/pecl install imagick

# copy php config file with redis.so extension
cp $base/templates/php-fpm/php$version.ini /opt/php/etc/php.ini

systemctl daemon-reload
systemctl enable php-fpm
systemctl start php-fpm

# make php command avaliable
ln /opt/php/bin/php /usr/bin/php
