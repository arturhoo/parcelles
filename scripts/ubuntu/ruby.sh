#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

su - ubuntu -c 'echo "gem: --no-ri --no-rdoc" >> ~/.gemrc'

for version in $rubies
do
    su - ubuntu <<EOF
    rbenv install $version
    rbenv global $version
    gem install bundler
    rbenv rehash
EOF
done
