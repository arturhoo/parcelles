#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

# MySQL or MongoDB partition
if [ -b /dev/xvdf ]; then
    apt-get update -q
    apt-get install xfsprogs -q -y
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdf
    mkfs.xfs /dev/xvdf1
fi

# Nginx partition
if [ -b /dev/xvdg ]; then
    (echo n; echo p; echo 1; echo ; echo ; echo w;) | fdisk /dev/xvdg
    mkfs.ext4 /dev/xvdg1
fi
