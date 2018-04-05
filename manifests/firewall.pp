class ducktape::firewall (
  $enabled = true,
  $purge_firewall = true,
  $purge_firewallchain = true,
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

