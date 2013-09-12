#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install mysql-server libmysql++-dev -y

sudo -u ubuntu mysql -uroot --execute="grant all privileges on *.* to '$USER'@'localhost'"
