class ducktape::ldap (
  Boolean $enabled,
  Hash $entry_defaults,
  Hash $entries,
) {

  if $enabled {
    include ducktape::ldap::autoload
  }

}
