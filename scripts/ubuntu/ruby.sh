#!/bin/bash -eux

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
