#!/bin/bash -eux

apt-get update -q
apt-get install xfsprogs -q -y

if [ -b /dev/xvdf ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdf
    mkfs.xfs /dev/xvdf1
    echo "/dev/xvdf1      /var/lib/mongodb xfs noatime,noexec,nodiratime 0 0" >> /etc/fstab
    mount -a
fi
