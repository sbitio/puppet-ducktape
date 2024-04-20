class ducktape::gluster (
  Boolean $enabled = true,
  Hash $mount_defaults = {},
  Hash $mounts = {},
) {
  if $enabled {
    include ducktape::gluster::autoload
  }

  case $facts['os']['family'] {
    'Debian': {
      apt::key { 'gluster':
        id     => 'A4703C37D3F4DE7F1819E980FE79BB52D5DC52DC',
        server => 'keys.gnupg.net',
        notify => Class['apt::update'],
      }
    }
    default: {
      fail("Unsupported platform: ${facts['os']['family']}")
    }
  }
}
