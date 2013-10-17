class nginx {
  exec { "Register ppa:nginx/stable":
    require => Package["python-software-properties"],
    command => "apt-add-repository ppa:nginx/stable -y &&
                apt-get update",
    creates => "/etc/apt/sources.list.d/nginx-stable-${::lsbdistcodename}.list",
    logoutput => true,
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
    recurse => true,
  } ->
  user { "ubuntu":
    groups => "www-data",
  }

  if $::ec2_ami_id and "xvdg1" in $::lsblk {
    # TODO: mount partition
    notify { "mount partition":
      before => File["/srv/www"]
    }
  }
}
