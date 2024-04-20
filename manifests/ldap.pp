class ducktape::ldap (
  Boolean $enabled = true,
  Hash $entry_defaults = {},
  Hash $entries = {},
) {
  if $enabled {
    include ducktape::ldap::autoload
  }
}
