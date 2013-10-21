class ruby (
  $version = "1.9.3-p448"
) {

  rbenv::install { "ubuntu": }
  ->
  rbenv::compile { $version:
    user => "ubuntu"
  }
}
