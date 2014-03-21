#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

add-apt-repository -y ppa:alestic
apt-get update -q
apt-get install liblocal-lib-perl ec2-consistent-snapshot -q -y

PERL_MM_USE_DEFAULT=1 cpan Net::Amazon::EC2
PERL_MM_USE_DEFAULT=1 cpan -fi MongoDB MongoDB::Admin
PERL_MM_USE_DEFAULT=1 cpan -fi Any Any::Moose

sudo -u ubuntu wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
sudo -u ubuntu unzip ec2-api-tools.zip
sudo -u ubuntu mv $(compgen -A file ec2-api-tools-) ec2/
sudo -u ubuntu rm ec2-api-tools.zip
