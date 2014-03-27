#!/bin/bash -eux

OS_USER="$SUDO_USER"

su - $OS_USER -c 'echo "gem: --no-ri --no-rdoc" >> ~/.gemrc'

for version in $rubies
do
    su - $OS_USER <<EOF
    rbenv install $version
    rbenv global $version
    gem install bundler
    rbenv rehash
EOF
done
