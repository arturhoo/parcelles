class base {
  # Useful basic packages.
  package { [ "build-essential", "curl", "git", "htop", "ntp",
              "python-software-properties", "tmux", "tree",
              "unattended-upgrades", "unzip", "vim" ]:
    ensure => latest
  }

  # Vim AS THE ONE TRUE EDITOR!!!!
  exec { "vim as default editor":
    require => Package["vim"],
    command => "update-alternatives --set editor /usr/bin/vim.basic",
    unless => "update-alternatives --query editor | grep -q 'Value: /usr/bin/vim.basic'"
  }

  File {
    require => Package["unattended-upgrades"],
    ensure => present,
    owner => "root",
    group => "root",
    mode => 644
  }

  file {
    # Password-less sudo like default AWS Ubuntu AMI.
    "/etc/sudoers.d/90-cloudimg-ubuntu":
      require => [],
      mode => 440,
      content => "ubuntu ALL=(ALL) NOPASSWD:ALL";
    # Enable minor unattended security upgrades.
    "/etc/apt/apt.conf.d/50unattended-upgrades":
      content => regsubst("Unattended-Upgrade::Allowed-Origins {
                            \t\"Ubuntu precise-security\";
                            \t\"Ubuntu precise-updates\";
                          };", "^ +", "", "G");
    "/etc/apt/apt.conf.d/10periodic":
      content => regsubst("APT::Periodic::Update-Package-Lists \"1\";
                           APT::Periodic::Download-Upgradeable-Packages \"1\";
                           APT::Periodic::AutocleanInterval \"7\";
                           APT::Periodic::Unattended-Upgrade \"1\";", "^ +", "", "G");
    "/home/ubuntu/.tmux.conf":
      require => Package["tmux"],
      source => "puppet:///modules/base/.tmux.conf",
      owner => "ubuntu",
      group => "ubuntu"
  }


  # SSH Settings for smooth deployment.
  service { "ssh":
    ensure => running,
    hasrestart => true
  }

  augeas { "sshd_config":
    require => File["/etc/sudoers.d/90-cloudimg-ubuntu"],
    notify => Service["ssh"],
    context => "/files/etc/ssh/sshd_config",
    changes => [ "set PasswordAuthentication no",
                 "set AllowAgentForwarding yes",
                 "set ClientAliveInterval 60",
                 "set ClientAliveCountMax 60" ]
  }

  # Timestamp on bash history for all users.
  augeas { "timestamp":
    lens => "Shellvars.lns",
    incl => "/etc/profile",
    changes => "set /files/etc/profile/HISTTIMEFORMAT '\"%F %T\"'"
  }

  # Prevent time slips syncing with ntp.
  service { "ntp":
    require => Package["ntp"],
    ensure => running
  }

  # Always sync on puppet execution.
  exec { "Sync clock":
    notify => Service["ntp"],
    command => "service ntp stop && 
                ntpdate ntp.ubuntu.com"
  }

  # Load ssh keys.
  $ssh_keys_defaults = {
    "user" => "ubuntu"
  }
  create_resources(ssh_authorized_key, hiera("ssh_keys"), $ssh_keys_defaults)
}
