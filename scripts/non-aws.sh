#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

# Insert ubuntu to the end of the sudoers list
cat /etc/sudoers > /tmp/sudoers.tmp
echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /tmp/sudoers.tmp
install -o root -g root -m 0440 /tmp/sudoers.tmp /etc/sudoers
rm /tmp/sudoers.tmp
