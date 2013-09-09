#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

# Enable bash history timestamping
TIMESTAMP='export HISTTIMEFORMAT="%F %T "'
echo $TIMESTAMP | sudo tee -a /etc/profile
eval $TIMESTAMP

# Configure basic packages to install non interactively
add-apt-repository -y ppa:nginx/stable
apt-get update

apt-get install build-essential git htop vim tmux nginx -y

# Install and configure unattended upgrades
apt-get install unattended-upgrades -y
echo "APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"7\";
APT::Periodic::Unattended-Upgrade \"1\";" | tee /etc/apt/apt.conf.d/10periodic
echo "Unattended-Upgrade::Allowed-Origins {
    \"Ubuntu precise-security\";
//  \"Ubuntu precise-updates\";
};" | tee /etc/apt/apt.conf.d/50unattended-upgrades

# Make sure server has the most up-to-date packages and kernel
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# Make vim the default editor
update-alternatives --set editor /usr/bin/vim.basic

# Keep long SSH connections running, especially for assets precompilation
echo "AllowAgentForwarding yes
 
ClientAliveInterval 60
ClientAliveCountMax 60" | tee -a /etc/ssh/sshd_config
service ssh restart
