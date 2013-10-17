class mongodb {
  exec { "Register 10gen apt-key":
    before => Package["mongodb-10gen"],
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
    unless => "apt-key list | grep -q 7F0CEB10",
    logoutput => true,
  }
  file { "/etc/apt/sources.list.d/mongodb.list":
    before => Package["mongodb-10gen"],
    content => "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen\n"
  } ~>
  exec { "apt-get update":
    command => "apt-get update",
    refreshonly => true
  } ->
  package { "mongodb-10gen":
    ensure => latest
  }

  if $::ec2_ami_id and "xvdf1" in $::lsblk {
    # TODO: mount partition
    notify { "mount partition":
      before => File["var/lib/mongodb"]
    }
  }
}
