class ducktape::gluster (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::gluster::autoload
  }

  case $::osfamily {
    'Debian': {
      apt::key { 'gluster':
        key        => "A4703C37D3F4DE7F1819E980FE79BB52D5DC52DC",
        key_server => "keys.gnupg.net",
        notify     => Class['apt::update'],
      }
    }
  }

}

