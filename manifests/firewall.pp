class ducktape::firewall (
  Boolean $enabled,
  Boolean $purge_firewall,
  Boolean $purge_firewallchain,
  Hash $rules,
  Hash $rule_defaults,
  Hash $chains,
  Hash $chain_defaults,
) {

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
