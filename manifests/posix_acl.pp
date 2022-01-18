class ducktape::posix_acl (
  Boolean $enabled = true,
  Hash $acl_defaults = {},
  Hash $acls = {},
) {

  if $enabled {
    contain ducktape::posix_acl::autoload
  }

}
