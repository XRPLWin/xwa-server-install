#!/bin/bash
set -e
echo 'Installer: Percona Server 8.4 (InnoDB/XtraDB only)'

apt-get update
apt-get install -y curl gnupg2 lsb-release

curl -o /tmp/percona-release_latest.generic_all.deb https://repo.percona.com/apt/percona-release_latest.generic_all.deb
apt-get install -y /tmp/percona-release_latest.generic_all.deb
apt-get update

percona-release setup ps-84-lts --scheme https
apt-get update

apt-get install -y percona-server-server percona-server-client

mysql -u root -e "CREATE USER 'root'@'127.0.0.1' IDENTIFIED BY 'mypass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"

echo '[mysqld]
default-storage-engine=innodb' > /etc/mysql/conf.d/storage-engine.cnf

systemctl restart mysql
systemctl enable mysql

echo 'Percona Server 8.4 installed (InnoDB default)!'
