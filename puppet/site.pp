node default {
  Exec {
    path => $::path,
  }

  include base

  include nginx

  include mysql
  #include mongodb

  #include php
  class { "ruby":
    version => "1.9.3-p448"
  }
}
