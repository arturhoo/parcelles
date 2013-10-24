class ruby (
  $user = "ubuntu",
  $version = "1.9.3-p448"
) {
  # YUI Compressor gem needs it
  require java

  rbenv::install { $user: }
  ->
  rbenv::compile { $version:
    user => $user,
    global => true
  }
}
