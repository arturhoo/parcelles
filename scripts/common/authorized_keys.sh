#!/bin/bash -eux

OS_USER="$SUDO_USER"

mkdir -p /home/$OS_USER/.ssh
cat /tmp/authorized_keys | tee -a /home/$OS_USER/.ssh/authorized_keys
chown -R $OS_USER:$OS_USER /home/$OS_USER/.ssh
chown 600 /home/$OS_USER/.ssh/authorized_keys
