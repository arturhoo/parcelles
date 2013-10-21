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

  # Perl Deps for ec2-consistent-snapshot
  require cpan
  cpan { [ "Net::Amazon::EC2", "MongoDB::Admin", "Any::Moose"]:
    require => Package["liblocal-lib-perl"],
    ensure => present
  }

  # EC2 api tools
  $ec2_api_tools = "http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip"
  exec { "Install ec2-api-tools":
    require => Package["oracle-java7-installer"],
    command => "wget ${ec2_api_tools} &&
                unzip ec2-api-tools.zip &&
                echo 'mv $(compgen -A file ec2-api-tools-) /home/ubuntu/ec2/' | bash &&
                rm ec2-api-tools.zip",
    creates => "/home/ubuntu/ec2",
    user => "ubuntu"
  }
}
