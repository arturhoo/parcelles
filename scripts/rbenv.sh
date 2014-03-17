#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

apt-add-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | \
     debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
     debconf-set-selections
apt-get install zlib1g-dev curl libssl-dev libsqlite3-dev nodejs \
                libreadline-gplv2-dev libtinfo-dev imagemagick tklib \
                libmagickwand-dev oracle-java7-installer libxml2 libxml2-dev \
                libxslt1-dev -y
su - ubuntu -c 'curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash'

read -d '' RBENV_SNIPPET <<"EOF"
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
EOF
echo "$RBENV_SNIPPET" | tee -a /home/ubuntu/.profile
