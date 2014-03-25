#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

if [ -b /dev/xvdf ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdg
    mkfs.ext4 /dev/xvdg1
    echo "/dev/xvdg1      /srv/www ext4 noatime,noexec,nodiratime 0 0" >> /etc/fstab
    mkdir -m 000 /srv/www
    mount /srv/www
fi
