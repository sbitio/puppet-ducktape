class ducktape::firewall (
  $enabled = true,
  $purge_firewall = false,
  $purge_firewallchain = false,
) {

  validate_bool($enabled)
  validate_bool($purge_firewall)
  validate_bool($purge_firewallchain)

  if $enabled {
    resources { 'firewall':
      purge => $purge_firewall,
    }

    resources { 'firewallchain':
      purge => $purge_firewallchain,
    }

    include ducktape::firewall::autoload
  }

}

