class ducktape::ldap::autoload(
  Boolean $entry       = true,
  Hash $entry_defaults = {},
  Hash $entries        = {},
) {

  if $entry {
    create_resources('ldap_entry', $entries, $entry_defaults)
  }

}
