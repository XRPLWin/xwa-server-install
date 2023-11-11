#!/bin/bash

echo 'XWA Installer: Percona MyRocks'

sudo apt update
sudo apt install curl
curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo apt install -y gnupg2 lsb-release ./percona-release_latest.generic_all.deb










yum -y update
yum -y install epel-release nano net-tools openssh-server which unzip tar




echo 'XWA Installer: Installing Percona with RocksDB...'

# Remove conflicts
yum -y remove mariadb
#useradd mysql

yum -y install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
yum -y install Percona-Server-rocksdb-57.x86_64
percona-release setup ps57

systemctl restart mysql

echo 'Your mysql root password:'
sudo grep 'temporary password' /var/log/mysqld.log
mysql --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MYXWA.Password1';flush privileges;"
#sad editiraj /etc/percona-server.conf.d/mysqld.cnf i dodaj:
#[client]
#user=root
#password=MYXWA.Password1


systemctl restart mysql



# ps-admin --enable-rocksdb -u <mysql_admin_user> -p[mysql_admin_pass] [-S <socket>] [-h <host> -P <port>]
ps-admin --enable-rocksdb -u root -pMYXWA.Password1 -S /var/lib/mysql/mysql.sock


#!includedir /etc/my.cnf.d/
#!includedir /etc/percona-server.conf.d/
