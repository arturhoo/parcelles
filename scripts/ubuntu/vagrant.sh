#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

mkdir /home/ubuntu/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu /home/ubuntu/.ssh
chmod -R go-rwsx /home/ubuntu/.ssh
