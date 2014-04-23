#!/bin/bash -eux

# Insert ubuntu to the end of the sudoers list
cat /etc/sudoers > /tmp/sudoers.tmp
echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /tmp/sudoers.tmp
install -o root -g root -m 0440 /tmp/sudoers.tmp /etc/sudoers
rm /tmp/sudoers.tmp

apt-get install cloud-init cloud-initramfs-growroot -qy
