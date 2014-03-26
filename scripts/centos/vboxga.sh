#!/bin/bash -eux

mkdir /tmp/vbox
VER=$(cat /home/centos/.vbox_version)
mount -o loop /home/centos/VBoxGuestAdditions_$VER.iso /tmp/vbox
sh /tmp/vbox/VBoxLinuxAdditions.run
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/centos/*.iso
