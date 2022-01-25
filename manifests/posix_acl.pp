class ducktape::posix_acl (
  Boolean $enabled,
  Hash $acl_defaults,
  Hash $acls,
) {

  if $enabled {
    contain ducktape::posix_acl::autoload
  }

}
