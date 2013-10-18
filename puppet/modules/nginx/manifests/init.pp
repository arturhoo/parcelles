class nginx {
  exec { "Register ppa:nginx/stable":
    require => Package["python-software-properties"],
    command => "apt-add-repository ppa:nginx/stable -y &&
                apt-get update",
    creates => "/etc/apt/sources.list.d/nginx-stable-${::lsbdistcodename}.list",
  } ->
  package { "nginx":
    ensure => latest
  } ->
  file { "/srv/www":
    require => Package['nginx'],
    ensure => directory,
    owner => "www-data",
    group => "www-data",
    mode => 755,
    recurse => true
  } ->
  user { "ubuntu":
    groups => "www-data"
  }

  if $::ec2_ami_id and "xvdg1" in $::lsblk {
    mount { "/srv/www":
      require => File["/srv/www"],
      ensure => mounted,
      atboot => true,
      device => "/dev/xvdg1",
      fstype => "ext4",
      options => "noatime,noexec,nodiratime",
      dump => 0,
      pass => 0
    }
  }
}
