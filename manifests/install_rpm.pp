define ducktape::install_rpm($source) {
  package { $name:
    ensure   => present,
    provider => rpm,
    source   => $source,
  }
}

