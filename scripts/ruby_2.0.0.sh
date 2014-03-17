#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

su - ubuntu -c 'rbenv install 2.0.0'
su - ubuntu -c 'rbenv global 2.0.0'
su - ubuntu -c 'echo "gem: --no-ri --no-rdoc" >> ~/.gemrc'
su - ubuntu -c 'gem install bundler'
su - ubuntu -c 'rbenv rehash'
