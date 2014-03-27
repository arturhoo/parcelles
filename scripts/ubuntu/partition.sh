#!/bin/bash -eux

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
