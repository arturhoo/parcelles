#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

mkdir -p /srv/www

if [ -b /dev/xvdg ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdg
    mkfs.ext4 /dev/xvdg1
    echo "/dev/xvdg1      /srv/www ext4 noatime,noexec,nodiratime 0 0" >> /etc/fstab
    mount -a
fi

chown -R www-data:www-data /srv/www
chmod -R 755 /srv/www

usermod -G www-data ubuntu
