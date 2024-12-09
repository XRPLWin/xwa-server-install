#!/bin/bash

version=1.24.0

base=/root/deploy

# apt install -y

mkdir -p /root/sw/nginx
# this is installed after php8 install, so they might be depencdecies that are missing that came from php installation.
apt install -y libpcre3-dev gcc

wget http://nginx.org/download/nginx-$version.tar.gz -O /root/sw/nginx/nginx-$version.tar.gz
tar vfx /root/sw/nginx/nginx-$version.tar.gz -C /root/sw/nginx/
cd /root/sw/nginx/nginx-$version
./configure --prefix=/opt/nginx-$version --with-http_gunzip_module --with-http_gzip_static_module --with-http_ssl_module --with-http_stub_status_module --with-http_v2_module --with-stream --with-stream_ssl_module
make && make install
ln -s /opt/nginx-$version /opt/nginx


cp $base/templates/nginx/nginx.service /etc/systemd/system/nginx.service

cp $base/templates/nginx/nginx.conf /opt/nginx-$version/conf/nginx.conf
cp $base/templates/nginx/fastcgi_params /opt/nginx-$version/conf/fastcgi_params

mkdir -p /opt/nginx-$version/conf/vhosts
mkdir -p /opt/nginx-$version/htdocs
chmod 0750 /opt/nginx-$version/htdocs
chown root:daemon /opt/nginx-$version/htdocs

mkdir -p /opt/nginx-$version/logs/vhost
chmod 0750 /opt/nginx-$version/logs/vhost
chown root:root /opt/nginx-$version/logs/vhost

#ln -s /opt/nginx /var/www

# create default site (directory)
mkdir -p /opt/nginx-$version/htdocs/default
cp $base/templates/nginx/default.index.html /opt/nginx-$version/htdocs/default/index.html
chmod -R 0750 /opt/nginx-$version/htdocs/default
chown -R root:daemon /opt/nginx-$version/htdocs/default

# Reload services
systemctl daemon-reload

# Start nginx service
systemctl enable nginx.service

# Start nginx service
systemctl start nginx.service

# Install firewall
apt install -y firewalld
# Configure firewall
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload
