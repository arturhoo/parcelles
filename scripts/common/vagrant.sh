#!/bin/bash -eux

OS_USER="$SUDO_USER"

mkdir /home/$OS_USER/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/$OS_USER/.ssh/authorized_keys
chown -R $OS_USER /home/$OS_USER/.ssh
chmod -R go-rwsx /home/$OS_USER/.ssh
