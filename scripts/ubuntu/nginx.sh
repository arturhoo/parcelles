#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

add-apt-repository -y ppa:nginx/stable
apt-get update -q
apt-get install nginx -qy

mkdir -p /srv/www
chown -R www-data:www-data /srv/www
chmod -R 755 /srv/www
usermod -a -G www-data ubuntu
