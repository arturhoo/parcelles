node default {
  Exec {
    path => $::path,
  }

  include base
  include mysql
  #include mongodb
  include nginx
  include php
  include ec2tools
}
