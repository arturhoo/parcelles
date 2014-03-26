#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

mkdir /tmp/vbox
VER=$(cat /home/ubuntu/.vbox_version)
mount -o loop /home/ubuntu/VBoxGuestAdditions_$VER.iso /tmp/vbox
sh /tmp/vbox/VBoxLinuxAdditions.run
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/ubuntu/*.iso
