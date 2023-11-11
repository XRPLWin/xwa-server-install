#!/bin/bash

# REDIS
###########################

base=/root/deploy

apt install -y redis

# backup original
cp /etc/redis/redis.conf /etc/redis/redis.backup

# copy optimized ( https://www.linode.com/docs/databases/redis/install-and-configure-redis-on-centos-7 )
cp $base/templates/redis/redis.conf /etc/redis/redis.conf

#systemctl enable redis
systemctl start redis

# fine tuning
sysctl vm.overcommit_memory=1

echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf

systemctl restart redis
