#!/bin/bash
set -e
echo 'Installer: Percona Server 8.4 (InnoDB/XtraDB only)'

# Install prerequisites
apt-get update
apt-get install -y curl gnupg2 lsb-release

# Download and install Percona release package
curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
apt-get install -y ./percona-release_latest.generic_all.deb
apt-get update

# Enable Percona Server 8.4 repo (ps84 instead of ps80)
percona-release setup ps84

apt-get update

# Install Percona Server 8.4 (base + client only, no rocksdb)
apt-get install -y percona-server-server percona-server-client

# Add admin user (root has no password with --initialize-insecure style installs,
# but apt installs prompt during setup — adjust if needed)
mysql -u root -e "CREATE USER 'crodigit'@'127.0.0.1' IDENTIFIED BY 'cdpass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'crodigit'@'127.0.0.1' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"

# Confirm InnoDB is default (it already is, but explicit is better)
echo '[mysqld]
default-storage-engine=innodb' > /etc/mysql/conf.d/storage-engine.cnf

systemctl restart mysql
systemctl enable mysql

echo 'Percona Server 8.4 installed (InnoDB default, no RocksDB)!'
