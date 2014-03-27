#!/bin/bash -eux

OS_USER=$(logname)

mkdir /tmp/vbox
VER=$(cat /home/$OS_USER/.vbox_version)
mount -o loop /home/$OS_USER/VBoxGuestAdditions_$VER.iso /tmp/vbox
sh /tmp/vbox/VBoxLinuxAdditions.run
umount /tmp/vbox
rmdir /tmp/vbox
rm /home/$OS_USER/*.iso
