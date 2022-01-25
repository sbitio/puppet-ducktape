class ducktape::ldap::autoload(
  Boolean $entry,
) {

  if $entry {
    create_resources('ldap_entry', $ducktape::ldap::entries, $ducktape::ldap::entry_defaults)
  }

}
