class mysql {
  package { [ "mysql-server", 'libmysql++-dev' ]:
    ensure => latest
  }

  exec { "Add ubuntu user":
    require => Package["mysql-server"],
    command => "mysql -uroot \
                --execute=\"GRANT ALL PRIVILEGES ON *.* TO 'ubuntu'@'%'\"",
    unless => "mysql -uroot --batch --skip-column-names \
               --execute=\"SELECT User FROM mysql.user WHERE User = 'ubuntu' AND Host = '%';\" | grep -q ubuntu"
  }

  if $::ec2_ami_id and "xvdf1" in $::lsblk {
    # TODO: mount partition
    notify { "mount partition":
      before => File["var/lib/mysql"]
    }
  }
}
