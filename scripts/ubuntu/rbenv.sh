#!/bin/bash -eux

apt-get install zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
                libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev \
                libcurl4-openssl-dev imagemagick libmagickwand-dev -q -y
su - ubuntu -c 'curl https://raw.githubusercontent.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash'

read -d '' RBENV_SNIPPET <<"EOF"
export RBENV_ROOT="${HOME}/.rbenv"

if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi
EOF
echo "$RBENV_SNIPPET" | tee -a /home/ubuntu/.profile
