#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list.d/10gen.list
apt-get update -q
apt-get install mongodb-10gen -q -y
