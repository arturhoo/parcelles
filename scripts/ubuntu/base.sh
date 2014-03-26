#!/bin/bash -eux

if [ "$(id -u)" != "0" ]; then
    echo Needs to run as root. 1>&2
    exit 1
fi

# Enable bash history timestamping
TIMESTAMP='export HISTTIMEFORMAT="%F %T "'
echo $TIMESTAMP | tee -a /etc/profile
eval $TIMESTAMP

apt-get install python-software-properties build-essential curl git htop ntp \
                tmux unzip vim unattended-upgrades linux-headers-$(uname -r) \
                dkms -qy

# Configure unattended upgrades
echo "APT::Periodic::Update-Package-Lists \"1\";
APT::Periodic::Download-Upgradeable-Packages \"1\";
APT::Periodic::AutocleanInterval \"7\";
APT::Periodic::Unattended-Upgrade \"1\";" | tee /etc/apt/apt.conf.d/10periodic
echo "Unattended-Upgrade::Allowed-Origins {
    \"Ubuntu precise-security\";
//  \"Ubuntu precise-updates\";
};" | tee /etc/apt/apt.conf.d/50unattended-upgrades

# Make vim the default editor
update-alternatives --set editor /usr/bin/vim.basic

# Keep long SSH connections running, especially for assets precompilation
echo "AllowAgentForwarding yes

ClientAliveInterval 60
ClientAliveCountMax 60" | tee -a /etc/ssh/sshd_config
service ssh restart
