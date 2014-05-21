#!/bin/bash -eux

apt-get install zlib1g-dev curl libssl-dev libsqlite3-dev nodejs \
                libreadline-gplv2-dev libtinfo-dev imagemagick tklib \
                libmagickwand-dev libxml2 libxml2-dev \
                libxslt1-dev -q -y
su - ubuntu -c 'curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash'

read -d '' RBENV_SNIPPET <<"EOF"
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
EOF
echo "$RBENV_SNIPPET" | tee -a /home/ubuntu/.profile
