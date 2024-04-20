class ducktape::ldap::autoload (
  Boolean $entry = true,
) {
  if $entry {
    create_resources('ldap_entry', $ducktape::ldap::entries, $ducktape::ldap::entry_defaults)
  }
}
