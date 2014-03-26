#!/bin/bash -eux

mkdir /home/centos/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/centos/.ssh/authorized_keys
chown -R centos /home/centos/.ssh
chmod -R go-rwsx /home/centos/.ssh
