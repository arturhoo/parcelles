#!/bin/bash -eux

apt-get update -q
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" \
                                       -o Dpkg::Options::="--force-confold" \
                                       -qy dist-upgrade
reboot
