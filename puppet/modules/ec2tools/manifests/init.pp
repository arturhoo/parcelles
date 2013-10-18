class ec2tools {
  exec { "Register ppa:alestic":
    require => Package["python-software-properties"],
    before => Package["ec2-consistent-snapshot"],
    command => "apt-add-repository ppa:alestic -y &&
                apt-get update",
    creates => "/etc/apt/sources.list.d/alestic-ppa-${::lsbdistcodename}.list",
  }

  exec { "Register ppa:webupd8team/java":
    require => Package["python-software-properties"],
    before => Package["oracle-java7-installer"],
    command => "apt-add-repository ppa:webupd8team/java -y &&
                apt-get update",
    creates => "/etc/apt/sources.list.d/webupd8team-java-${::lsbdistcodename}.list",
  }

  exec { "Accept Oracle License":
    before => Package["oracle-java7-installer"],
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections &&
                echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections",
    unless => "sudo debconf-get-selections | grep accepted-oracle-license-v1-1 | grep -q true",
  }

  package { [ "liblocal-lib-perl", "ec2-consistent-snapshot",
              "oracle-java7-installer" ]:
    ensure => latest
  }

  #TODO: Perl deps
  #TODO: ec2 api java tools
}
