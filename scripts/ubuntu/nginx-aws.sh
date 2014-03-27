#!/bin/bash -eux

if [ -b /dev/xvdf ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdg
    mkfs.ext4 /dev/xvdg1
    echo "/dev/xvdg1      /srv/www ext4 noatime,noexec,nodiratime 0 0" >> /etc/fstab
    mkdir -m 000 /srv/www
    mount /srv/www
fi
