class ducktape::ldap (
  $enabled = true,
) {

  validate_bool($enabled)

  if $enabled {
    include ducktape::ldap::autoload
  }

}
