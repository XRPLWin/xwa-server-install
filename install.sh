#!/bin/bash

echo 'XWA Installer: Percona MyRocks'

#see https://docs.percona.com/percona-server/8.0/install-myrocks.html#install-percona-myrocks

sudo apt update
sudo apt install curl
curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo apt install -y gnupg2 lsb-release ./percona-release_latest.generic_all.deb
sudo apt update

percona-release setup ps80
sudo apt install -y percona-server-rocksdb
# USER INPUT: You will be asked to enter mysql root password (in this example MyPASSWORD) then "Use Strong Encryption"
# My location: /etc/mysql/my.cnf
# Symlink: /etc/systemd/system/multi-user.target.wants/mysql.service → /lib/systemd/system/mysql.service

# Enable myrocks:
# ps-admin --enable-rocksdb -u <mysql_admin_user> -p[mysql_admin_pass] [-S <socket>] [-h <host> -P <port>]
ps-admin --enable-rocksdb -u root -pMyPASSWORD

echo 'Percona MyRocks installed!'
