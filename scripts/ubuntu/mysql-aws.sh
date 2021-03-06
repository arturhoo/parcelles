#!/bin/bash -eux

apt-get install xfsprogs -qy

if [ -b /dev/xvdf ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdf
    mkfs.xfs /dev/xvdf1
    echo "/dev/xvdf1      /var/lib/mysql xfs noatime,noexec,nodiratime 0 0" >> /etc/fstab
    mkdir -m 000 /var/lib/mysql
    mount /var/lib/mysql
fi
