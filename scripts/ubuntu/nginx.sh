#!/bin/bash -eux

add-apt-repository -y ppa:nginx/stable
apt-get update -q
apt-get install nginx -qy

mkdir -p /srv/www
chown -R www-data:www-data /srv/www
chmod -R 755 /srv/www
usermod -a -G www-data ubuntu

cp /tmp/nginx.conf /etc/nginx/nginx.conf
service nginx restart
