#!/bin/bash -eux

apt-get update -q
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server libmysql++-dev -q -y

mysql -uroot --execute="grant all privileges on *.* to 'ubuntu'@'localhost'"
